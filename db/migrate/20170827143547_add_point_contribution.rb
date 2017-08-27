class AddPointContribution < ActiveRecord::Migration[5.0]
  def change
    add_column :contributions, :point, :integer
  end
end
