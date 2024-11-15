class DocumentPage < ApplicationRecord
  belongs_to :account
  belongs_to :document
  has_one_attached :preview
end
