class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.boolean :operation
      t.string :address
      t.integer :price
      t.string :type
      t.string :bedrooms
      t.string :bathrooms
      t.float :area
      t.boolean :pets
      t.text :about
      t.boolean :active
      t.references :landlord, null: false, foreign_key: true
      t.references :saved, null: true, foreign_key: true

      t.timestamps
    end
  end
end
