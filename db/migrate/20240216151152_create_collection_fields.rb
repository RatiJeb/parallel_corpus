class CreateCollectionFields < ActiveRecord::Migration[7.1]
  def change
    create_table :collection_fields do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.index [:collection_id, :field_id], unique: true

      t.timestamps
    end
  end
end
