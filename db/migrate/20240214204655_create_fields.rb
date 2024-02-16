class CreateFields < ActiveRecord::Migration[7.1]
  def change
    create_table :fields do |t|
      t.string :name_ka
      t.string :name_en

      t.timestamps
    end
  end
end
