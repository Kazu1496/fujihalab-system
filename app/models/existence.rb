class Existence < ApplicationRecord
  belongs_to :user

  scope :order_by_enter_at, -> { order(created_at: :desc) }

  def previous
    Existence.where("user_id = ? and id < ?", self.user_id, self.id).order("id DESC").first
  end

  def next
    Existence.where("user_id = ? and id > ?", self.user_id, self.id).first
  end
end
