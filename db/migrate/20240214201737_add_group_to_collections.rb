class AddGroupToCollections < ActiveRecord::Migration[7.1]
  def change
    add_reference :collections, :group, null: false, foreign_key: true
  end
end
