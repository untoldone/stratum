class Document < ApplicationRecord
  belongs_to :account
  has_one_attached :file
  has_one_attached :processed_file
  has_one_attached :file_text
  has_many :pages, class_name: 'DocumentPage', dependent: :delete_all
  before_save :set_original_file_id
  after_save :process_document

  def best_file_available
    processed_file.attached? ? processed_file : file
  end

  def download_filename
    if self.interpretation
      ext = Mime::Type.lookup(self.best_file_available.content_type).symbol.to_s
      date = self.interpretation["date_written"]
      sender = self.interpretation["sender"]
      recipient = self.interpretation["recipient"] || self.interpretation["recipient_guess"]
      topic = self.interpretation["topic"]

      "#{date}-#{sender}-#{recipient}-#{topic}.#{ext}"
    else
      self.file.filename
    end
  end

  private
  def set_original_file_id
    @original_file_id = file.attachment&.blob_id if file.attached?
  end

  def process_document
    if file.attached? && file.attachment&.blob_id != @original_file_id
      ProcessDocumentJob.perform_later self
    end
  end
end
