class AddSupergroupToGroups < ActiveRecord::Migration[7.1]
  def change
    add_reference :groups, :supergroup, null: false, foreign_key: true
  end
end
