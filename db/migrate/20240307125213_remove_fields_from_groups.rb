class RemoveFieldsFromGroups < ActiveRecord::Migration[7.1]
  def change
    remove_column :groups, :year, :integer
    remove_column :groups, :translation_year, :integer
    remove_column :groups, :original_language, :integer
  end
end
