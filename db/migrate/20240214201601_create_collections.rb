class CreateCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :collections do |t|
      t.string :name_ka, null: false
      t.string :name_en, null: false
      t.text :comment
      t.text :additional_info
      t.integer :year
      t.integer :translation_year
      t.integer :original_language, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :old_id
      t.index :old_id, unique: true

      t.timestamps
    end
  end
end
