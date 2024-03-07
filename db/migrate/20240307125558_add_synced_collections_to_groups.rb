class AddSyncedCollectionsToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :should_sync, :boolean, null: false, default: false
  end
end
