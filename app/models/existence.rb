class Existence < ApplicationRecord
  belongs_to :user

  scope :order_by_enter_at, -> { order(enter_time: :desc) }
end
