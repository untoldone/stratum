class Device < ApplicationRecord
  belongs_to :account
  has_many :tokens, class_name: "DeviceToken"
  before_create :generate_token

  private
  def generate_token
    self.tokens << DeviceToken.new
  end
end
