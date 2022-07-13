class AdduniqueIndexToSaved < ActiveRecord::Migration[7.0]
  def change
    add_index :saveds, [:homeseeker_id, :property_id], unique: true
  end
end
