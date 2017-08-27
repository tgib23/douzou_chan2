class ChangeSumPointColumnOfUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :sum_point, :integer, null: false, :default => 0
  end
end
