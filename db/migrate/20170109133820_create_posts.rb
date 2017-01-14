class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :coordinate
      t.string :country
      t.string :province
      t.string :city
      t.text :address
      t.string :name
      t.integer :year
      t.text :link
      t.string :author
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
    add_index :posts, [:country, :province]
    add_index :posts, [:city, :author]
  end
end
