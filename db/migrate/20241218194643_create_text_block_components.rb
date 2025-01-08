class CreateTextBlockComponents < ActiveRecord::Migration[7.1]
  def change
    create_table :text_block_components do |t|
      t.string :value, index: { unique: true }
      t.integer :language, index: true
      t.timestamps
    end
  end
end
