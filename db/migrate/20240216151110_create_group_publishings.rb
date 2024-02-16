class CreateGroupPublishings < ActiveRecord::Migration[7.1]
  def change
    create_table :group_publishings do |t|
      t.references :group, null: false, foreign_key: true
      t.references :publishing, null: false, foreign_key: true
      t.index [:group_id, :publishing_id], unique: true

      t.timestamps
    end
  end
end
