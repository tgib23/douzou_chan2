class AddAddressjaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :address_ja, :string
  end
end
