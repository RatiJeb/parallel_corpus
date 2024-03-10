class CreateGroupDetails < ActiveRecord::Migration[7.1]
  def change
    create_view :group_details
  end
end
