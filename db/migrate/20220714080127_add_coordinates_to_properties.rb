class AddCoordinatesToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :latitude, :string
    add_column :properties, :longitude, :string
  end
end
