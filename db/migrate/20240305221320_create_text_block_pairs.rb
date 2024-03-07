class CreateTextBlockPairs < ActiveRecord::Migration[7.1]
  def change
    create_view :text_block_pairs
  end
end
