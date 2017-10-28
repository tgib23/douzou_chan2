class CreatePicLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :pic_likes do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end
