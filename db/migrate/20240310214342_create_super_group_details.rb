class CreateSuperGroupDetails < ActiveRecord::Migration[7.1]
  def change
    create_view :super_group_details
  end
end
