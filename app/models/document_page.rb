class DocumentPage < ApplicationRecord
  belongs_to :document
  has_one_attached :preview
end
