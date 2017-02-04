class AddLocalityToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :locality, :string
  end
end
