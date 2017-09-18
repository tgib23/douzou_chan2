class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :country, presence: true
  validates :country_ja, presence: true
  validates :administrative_area_level_1, presence: true
  validates :administrative_area_level_1_ja, presence: true
  validates :address, presence: true
  validates :address_ja, presence: true

  has_many :pics
  has_many :comments
  accepts_nested_attributes_for :pics
end
