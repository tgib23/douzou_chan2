class ChangeLongitudeagainToPost < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :longitude, :float, null: false
  end
end
