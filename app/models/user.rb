class User < ApplicationRecord
  has_many :existences, dependent: :destroy
  has_secure_password validations: true

  validates :name, :address, uniqueness: true
  validates :name, :address, :password_digest, presence: true

  mount_uploader :picture, PictureUploader

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
