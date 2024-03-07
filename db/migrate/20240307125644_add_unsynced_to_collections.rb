class AddUnsyncedToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :should_unsync, :boolean, null: false, default: false
  end
end
