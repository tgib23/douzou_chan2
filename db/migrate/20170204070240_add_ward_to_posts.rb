class AddWardToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :ward, :string
  end
end
