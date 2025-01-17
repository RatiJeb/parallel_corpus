class RemoveDuplicationFromTextBlockPairsView < ActiveRecord::Migration[7.1]
  def change
    drop_view(:text_block_pairs)
    create_view(:text_block_pairs)
  end
end
