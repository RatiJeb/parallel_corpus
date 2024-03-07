class DropTables < ActiveRecord::Migration[7.1]
  def change
    drop_table :group_authors
    drop_table :group_types
    drop_table :group_fields
    drop_table :group_genres
    drop_table :group_publishings
    drop_table :group_translators
  end
end
