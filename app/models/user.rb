class User < ApplicationRecord
  has_many :existences, dependent: :destroy
  has_secure_password validations: true

  validates :name, uniqueness: true

  mount_uploader :image, ImageUploader

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
