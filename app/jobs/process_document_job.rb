require "RMagick"

class ProcessDocumentJob < ApplicationJob
  queue_as :default

  def perform(document)
    Dir.mktmpdir do |output_dir|
      document.file.open do |file|
        pdf = Magick::ImageList.new(file.path) do |options|
          options.density = '200'
        end
        pdf.each_with_index do |page, index|
          page.format = 'png'
          page_image_path = File.join(output_dir, "page_#{index + 1}.png")

          page.write(page_image_path)

          DocumentPage.create!(preview: File.open(page_image_path), document: document, index: index)
        end
      end
    end
  end
end
