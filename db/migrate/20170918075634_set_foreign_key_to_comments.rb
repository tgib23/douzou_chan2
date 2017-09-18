class SetForeignKeyToComments < ActiveRecord::Migration[5.0]
  def change
    change_column :comments, :post_id, :integer, foreign_key: true
  end
end
