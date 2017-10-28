class ChangeKeyColumnOfLike < ActiveRecord::Migration[5.0]
  def change
    change_column :likes, :key, :string, null: false, :default => "key_should_be_specified"
  end
end
