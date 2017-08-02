class AddSub3jaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_3_ja, :string
  end
end
