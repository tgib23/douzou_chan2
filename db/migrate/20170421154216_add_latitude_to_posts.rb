class AddLatitudeToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :latitude, :string
  end
end
