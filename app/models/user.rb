class User < ApplicationRecord
  has_many :existences, dependent: :destroy
  has_secure_password
  
  mount_uploader :image, ImageUploader
end
