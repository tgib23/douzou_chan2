class AddCountryjaToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :country_ja, :string
  end
end
