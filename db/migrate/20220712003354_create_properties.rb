class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.integer :operation
      t.string :address
      t.integer :price
      t.integer :property_type
      t.integer :bedrooms, default: 0
      t.integer :bathrooms, default: 0
      t.float :area
      t.boolean :pets, default: false
      t.text :about
      t.boolean :active, default: true
      t.references :landlord, null: false, foreign_key: true

      t.timestamps
    end
  end
end
