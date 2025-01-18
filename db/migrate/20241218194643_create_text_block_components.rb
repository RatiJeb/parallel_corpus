class CreateTextBlockComponents < ActiveRecord::Migration[7.1]
  def change
    create_table :text_block_components do |t|
      t.string :value
    end

    add_index :text_block_components, :value
  end
end
