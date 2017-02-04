class AddSub2ToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_2, :string
  end
end
