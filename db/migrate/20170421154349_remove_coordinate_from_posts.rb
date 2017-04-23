class RemoveCoordinateFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :coordinate, :string
  end
end
