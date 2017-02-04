class AddAdminarea1ToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :administrative_area_level_1, :string
  end
end
