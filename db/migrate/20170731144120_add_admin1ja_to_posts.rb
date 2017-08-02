class AddAdmin1jaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :administrative_area_level_1_ja, :string
  end
end
