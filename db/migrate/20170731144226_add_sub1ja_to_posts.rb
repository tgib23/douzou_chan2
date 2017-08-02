class AddSub1jaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_1_ja, :string
  end
end
