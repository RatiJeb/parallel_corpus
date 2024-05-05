class AddOrderNumberToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :order_number, :integer
  end
end
