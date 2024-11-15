require "RMagick"

class ProcessDocumentJob < ApplicationJob
  queue_as :default

OPENAI_RULES = <<~EOS
You are helping me create file names and classify documents.

All responses must be in a JSON response with the following keys:
* date_written: The date the item was written or issued. If a date is not clearly the date that the document was written, this field must be null
* sender: The sender's name must match exactly how it appears in the document. If the sender's name is longer than 20 characters, abbreviate it or use a more general part of the name, ensuring it still clearly identifies the sender.
* recipient: if recipient does not confirm to the rules below, "unexpected" should be used as the value here
* recipient_guess: the recipient's name or organizations name. This field is only used if "recipient" is "unexpected"
* topic: short and consise name of the topic covered in the document. Might be the title of the document or other summary of the contents of the document


Notes:
* Recipient MUST appear in the document somwhere Recipient must be one of the following:
  * "Michael" -- for Michael Wasser's personal or family related items
  * "Jess" -- for Jessica Yamane's personal or family related items
  * "Emmett" -- for Emmett Wasser's personal or family related items
  * "Owen" -- for Owen Wasser's personal of family related items
  * "Exactly" -- for Exactly Labs, Inc. related items
  * "Neuranimus Inc" -- for Neuranimus, Inc. related items or items that seem related to Neuranimus all up
  * "Neuranimus CA" -- for Neuranimus, P.C. related items. This would include items related to the state of California for Neuranimus
  * "Neuranimus FL" -- for Neuranimus Medical of Florida PLLC related items
  * "Three Rivers" -- for Three Rivers Medical of New York PLLC related items
* Date should be the date of the letter being printed if present on the document, if not present on the document the date should be the date the document was received
An example of this format would be as follows:
2024-03-20-IRS-Exactly-Correspondence regarding 2022 Q4 Form 941.pdf
This indicates the correspondence was printed on March 20, 2024. The document is from the IRS and sent to Exactly Labs. The document itself is a letter related to Exactly Labs’ Form 941 submission for 2022 quarter 4.
* Reminder! The senders name MUST be fewer than 20 characters. Find a way to shorten the name if needed to meet this requirement.

Before showing me a response:
* Double check that the "sender" field is fewer than 20 characters
* Double check the date being shown is the date the document was written

All responses should be pure JSON only with no other context provided. Only one object should be returned, never return an array of objects.
EOS

  def perform(document)
    Dir.mktmpdir do |output_dir|
      document.file.open do |file|
        # --rotate-pages-threshold 4 lowers the default confidence to rotating a pdf
        # --output-type pdf outputs in pdf rather than pdf/a
        # --rotate-pages attempts to rotate pages if oriented the wrong direction
        # --deskew attempts to adjust for slight offsets from the document being scanned strait
        # --force-ocr Always redo OCR even when text is present
        ocrd_pdf_path = File.join(output_dir, "#{document.id}.pdf")
        `ocrmypdf --force-ocr --rotate-pages-threshold 4 --output-type pdf --rotate-pages --deskew #{file.path} #{ocrd_pdf_path}`
        document.update!(processed_file: File.open(ocrd_pdf_path))

        pdf = Magick::ImageList.new(ocrd_pdf_path) do |options|
          options.density = '200'
        end
        pdf.each_with_index do |page, index|
          page.format = 'png'
          page_image_path = File.join(output_dir, "page_#{index + 1}.png")

          page.write(page_image_path)

          DocumentPage.create!(preview: File.open(page_image_path), document: document, index: index)
        end

        pdf_text_path = File.join(output_dir, "#{document.id}.txt")
        # -layout tries to maintain the general layout of the PDF by using spaces etc. Otherwise, the text appears out of order if documents with complex relationships between data
        # -enc UTF-8 forces UTF-8 as its not the default on all platforms
        `pdftotext -enc UTF-8 -layout #{ocrd_pdf_path} #{pdf_text_path}`
        document.update!(file_text: File.open(pdf_text_path))

        file_text = File.read(pdf_text_path)
        client = OpenAI::Client.new
        api_response = client.chat(
          parameters: {
            messages: [
              { role: "user", content: "#{OPENAI_RULES}\n========\n#{file_text}"}
            ]
          }
        )

        puts api_response
        response = api_response["choices"][0]["message"]["content"].sub(/^```json/,"").sub(/```$/,"")
        puts response
        document.update(interpretation: JSON.parse(response))
      end
    end
  end
end
