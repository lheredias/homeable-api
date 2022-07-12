class ChangePropertiesColumnsTypes < ActiveRecord::Migration[7.0]
  def change
    change_column :properties, :type, :integer, using: "type::integer"
    change_column :properties, :bedrooms, :integer, using: "bedrooms::integer"
    change_column :properties, :bathrooms, :integer, using: "bathrooms::integer"
  end
end
