class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :coordinate, presence: true
  validates :country, presence: true
  validates :province, presence: true
  validates :city, presence: true
  validates :address, presence: true
end
