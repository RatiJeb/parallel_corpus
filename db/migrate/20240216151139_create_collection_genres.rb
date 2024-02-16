class CreateCollectionGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :collection_genres do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      t.index [:collection_id, :genre_id], unique: true

      t.timestamps
    end
  end
end
