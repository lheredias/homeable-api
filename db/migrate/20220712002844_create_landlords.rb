class CreateLandlords < ActiveRecord::Migration[7.0]
  def change
    create_table :landlords do |t|
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
