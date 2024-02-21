class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.string :name_ka
      t.string :name_en
      t.integer :status, null: false, default: 0
      t.text :comment
      t.integer :old_id
      t.index :old_id, unique: true

      t.timestamps
    end
  end
end
