class CreateSaveds < ActiveRecord::Migration[7.0]
  def change
    create_table :saveds do |t|
      t.boolean :contacted, default: false
      t.boolean :favorite, default: false
      t.references :homeseeker, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
