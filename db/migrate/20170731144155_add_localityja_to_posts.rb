class AddLocalityjaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :locality_ja, :string
  end
end
