class AddDefaultMaintenanceToProperty < ActiveRecord::Migration[7.0]
  def up
    change_column_default :properties, :maintenance, 0
  end

  def down
    change_column_default :properties, :maintenance, nil
  end
end
