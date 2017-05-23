class CreateContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :contributions do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :diff

      t.timestamps
    end
  end
end
