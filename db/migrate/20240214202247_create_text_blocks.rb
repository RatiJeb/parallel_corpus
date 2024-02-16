class CreateTextBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :text_blocks do |t|
      t.references :collection, null: false, foreign_key: true
      t.text :contents
      t.integer :order_number, null: false
      t.integer :language, null: false, default: 0
      t.index [:collection_id, :order_number, :language], unique: true

      t.timestamps
    end
  end
end
