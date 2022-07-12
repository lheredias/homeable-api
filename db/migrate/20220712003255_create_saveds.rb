class CreateSaveds < ActiveRecord::Migration[7.0]
  def change
    create_table :saveds do |t|
      t.boolean :contacted
      t.boolean :favorite
      t.references :homeseeker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
