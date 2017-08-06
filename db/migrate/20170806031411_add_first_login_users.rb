class AddFirstLoginUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_login, :integer, :default => 1
  end
end
