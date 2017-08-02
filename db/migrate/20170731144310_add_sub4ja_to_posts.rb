class AddSub4jaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_4_ja, :string
  end
end
