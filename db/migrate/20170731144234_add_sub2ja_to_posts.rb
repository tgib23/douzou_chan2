class AddSub2jaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_2_ja, :string
  end
end
