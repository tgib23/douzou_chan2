class RenameLikeToPostLike < ActiveRecord::Migration[5.0]
  def change
    rename_table :likes, :post_likes
  end
end
