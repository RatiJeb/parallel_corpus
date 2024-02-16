class CreateGroupTranslators < ActiveRecord::Migration[7.1]
  def change
    create_table :group_translators do |t|
      t.references :group, null: false, foreign_key: true
      t.references :translator, null: false, foreign_key: true
      t.index [:group_id, :translator_id], unique: true

      t.timestamps
    end
  end
end
