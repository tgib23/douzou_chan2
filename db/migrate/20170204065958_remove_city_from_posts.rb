class RemoveCityFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :city, :string
  end
end
