class AddIndexToComments < ActiveRecord::Migration[5.0]
  def change
    add_index :comments, [:user_id, :post_id, :created_at]
  end
end
