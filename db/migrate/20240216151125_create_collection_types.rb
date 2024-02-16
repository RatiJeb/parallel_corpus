class CreateCollectionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :collection_types do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.index [:collection_id, :type_id], unique: true

      t.timestamps
    end
  end
end
