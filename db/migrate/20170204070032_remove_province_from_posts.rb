class RemoveProvinceFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :province, :string
  end
end
