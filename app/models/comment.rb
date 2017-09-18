class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  default_scope -> { order(created_at: :asc) }
  validates :post_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 2000 }
end
