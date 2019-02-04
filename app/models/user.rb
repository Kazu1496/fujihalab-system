class User < ApplicationRecord
  has_many :existences, dependent: :destroy
end
