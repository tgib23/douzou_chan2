class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :coordinate, presence: true
  validates :country, presence: true
  validates :administrative_area_level_1, presence: true
  validates :address, presence: true
end
