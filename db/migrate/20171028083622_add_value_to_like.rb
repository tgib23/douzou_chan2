class AddValueToLike < ActiveRecord::Migration[5.0]
  def change
    add_column :likes, :value, :text
  end
end
