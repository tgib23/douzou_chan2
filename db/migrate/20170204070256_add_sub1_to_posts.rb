class AddSub1ToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_1, :string
  end
end
