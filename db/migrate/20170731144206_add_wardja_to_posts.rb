class AddWardjaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :ward_ja, :string
  end
end
