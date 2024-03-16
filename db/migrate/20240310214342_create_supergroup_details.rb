class CreateSupergroupDetails < ActiveRecord::Migration[7.1]
  def change
    create_view :supergroup_details
  end
end
