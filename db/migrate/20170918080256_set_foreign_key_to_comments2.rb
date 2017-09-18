class SetForeignKeyToComments2 < ActiveRecord::Migration[5.0]
  def change
    change_column :comments, :user_id, :integer, foreign_key: true
  end
end
