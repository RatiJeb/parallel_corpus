class CreateGarbage < ActiveRecord::Migration[7.1]
  def change
    create_table :garbages do |t|
      t.string :model
      t.string :snapshot

      t.timestamps
    end
  end
end
