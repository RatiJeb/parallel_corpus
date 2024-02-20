class CreateTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :terms do |t|
      t.integer :old_id
      t.integer :old_text_id
      t.text :term
      t.references :text_block, null: false, foreign_key: true

      t.timestamps
    end
  end
end
