class CreateGroupFields < ActiveRecord::Migration[7.1]
  def change
    create_table :group_fields do |t|
      t.references :group, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.index [:group_id, :field_id], unique: true

      t.timestamps
    end
  end
end
