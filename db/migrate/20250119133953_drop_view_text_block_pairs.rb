class DropViewTextBlockPairs < ActiveRecord::Migration[7.1]
  def up
    drop_view(:text_block_pairs)
  end

  def down
    create_view(:text_block_pairs)
  end
end
