class AddSub4ToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_4, :string
  end
end
