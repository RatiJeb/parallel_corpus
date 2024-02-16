class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.string :name_ka, null: false
      t.string :name_en, null: false
      t.text :comment
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
