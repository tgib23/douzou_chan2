class CreatePics < ActiveRecord::Migration[5.0]
  def change
    create_table :pics do |t|
      t.integer :pic_id
      t.string :avatar

      t.timestamps
    end
  end
end
