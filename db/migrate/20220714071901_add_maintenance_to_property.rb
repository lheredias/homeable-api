class AddMaintenanceToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :maintenance, :integer
  end
end
