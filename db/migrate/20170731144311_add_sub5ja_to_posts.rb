class AddSub5jaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_5_ja, :string
  end
end
