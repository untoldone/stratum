class Document < ApplicationRecord
  has_one_attached :file
  has_many :pages, class_name: 'DocumentPage', dependent: :delete_all
  after_save :process_document

  private
  def process_document
    ProcessDocumentJob.perform_later self
  end
end
