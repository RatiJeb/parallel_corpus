class CreateGroupGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :group_genres do |t|
      t.references :group, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      t.index [:group_id, :genre_id], unique: true

      t.timestamps
    end
  end
end
