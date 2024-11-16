class DeviceToken < ApplicationRecord
  belongs_to :device
  before_create :generate_token

  private
  def generate_token
    self.token = Base64.urlsafe_encode64(SecureRandom.random_bytes(33))
  end
end
