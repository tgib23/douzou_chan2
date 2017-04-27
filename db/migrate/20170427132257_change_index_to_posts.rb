class ChangeIndexToPosts < ActiveRecord::Migration[5.0]
  def change
    add_index :posts, :latitude
    add_index :posts, :longitude
    remove_index :posts, :country
    remove_index :posts, :author
  end
end
