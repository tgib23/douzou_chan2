class ChangeLangitudeToPost < ActiveRecord::Migration[5.0]
  def up
    change_column :posts, :latitude, :float, null: false
  end
  def down
    change_column :posts, :latitude, :string
  end
end
