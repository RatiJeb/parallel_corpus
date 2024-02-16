class CreateGroupTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :group_types do |t|
      t.references :group, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.index [:group_id, :type_id], unique: true

      t.timestamps
    end
  end
end
