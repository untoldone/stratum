class Correspondence < ApplicationRecord
  belongs_to :account
  belongs_to :document
end
