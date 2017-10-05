class AddWikipediaNameToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :wikipedia_name, :string
  end
end
