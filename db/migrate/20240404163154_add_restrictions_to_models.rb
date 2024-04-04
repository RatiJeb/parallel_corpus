class AddRestrictionsToModels < ActiveRecord::Migration[7.1]
  def change
    add_index :supergroups, [:name_ka], unique: true
    add_index :supergroups, [:name_en], unique: true

    add_index :groups, [:supergroup_id, :name_ka], unique: true
    add_index :groups, [:supergroup_id, :name_en], unique: true

    add_index :collections, [:group_id, :name_ka], unique: true
    add_index :collections, [:group_id, :name_en], unique: true

    add_index :authors, [:name_ka], unique: true
    add_index :authors, [:name_en], unique: true

    add_index :genres, [:name_ka, :name_en], unique: true

    add_index :fields, [:name_ka, :name_en], unique: true

    add_index :publishings, [:name_ka, :name_en], unique: true

    add_index :translators, [:name_ka], unique: true
    add_index :translators, [:name_en], unique: true

    add_index :types, [:name_ka, :name_en], unique: true
  end
end
