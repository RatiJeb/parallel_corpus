class CreateCollectionDetails < ActiveRecord::Migration[7.1]
  def change
    create_view :collection_details
  end
end
