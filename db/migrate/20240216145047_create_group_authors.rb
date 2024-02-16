class CreateGroupAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :group_authors do |t|
      t.references :group, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
      t.index [:group_id, :author_id], unique: true

      t.timestamps
    end
  end
end
