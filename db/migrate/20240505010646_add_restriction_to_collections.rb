class AddRestrictionToCollections < ActiveRecord::Migration[7.1]
  def change
    add_index :collections, [:group_id, :order_number], unique: true
  end
end
