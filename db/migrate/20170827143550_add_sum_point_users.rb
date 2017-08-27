class AddSumPointUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sum_point, :integer
  end
end
