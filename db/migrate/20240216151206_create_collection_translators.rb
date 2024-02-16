class CreateCollectionTranslators < ActiveRecord::Migration[7.1]
  def change
    create_table :collection_translators do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :translator, null: false, foreign_key: true
      t.index [:collection_id, :translator_id], unique: true

      t.timestamps
    end
  end
end
