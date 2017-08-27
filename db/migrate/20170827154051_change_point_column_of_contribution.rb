class ChangePointColumnOfContribution < ActiveRecord::Migration[5.0]
  def change
    change_column :contributions, :point, :integer, null: false, default: 0
  end
end
