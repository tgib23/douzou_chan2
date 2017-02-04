class AddSub5ToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sublocality_level_5, :string
  end
end
