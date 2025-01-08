class CreateTextBlockComponentPivots < ActiveRecord::Migration[7.1]
  def change
    create_table :text_block_component_pivots do |t|
      t.references :text_block, foreign_key: true, null: false
      t.references :text_block_component, foreign_key: true, null: false
      t.integer :position
    end

    add_index :text_block_component_pivots, [:text_block_component_id, :text_block_id, :position]
  end
end
