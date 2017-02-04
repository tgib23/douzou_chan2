class AddSub3ToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_3, :string
  end
end
