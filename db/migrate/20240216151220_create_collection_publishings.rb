class CreateCollectionPublishings < ActiveRecord::Migration[7.1]
  def change
    create_table :collection_publishings do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :publishing, null: false, foreign_key: true
      t.index [:collection_id, :publishing_id], unique: true

      t.timestamps
    end
  end
end
