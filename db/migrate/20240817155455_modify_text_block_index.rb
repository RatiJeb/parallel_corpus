class ModifyTextBlockIndex < ActiveRecord::Migration[7.1]
  def change
    add_unique_constraint :text_blocks, deferrable: :deferred, using_index: "idx_on_collection_id_order_number_language_42425d13fb"
  end
end
