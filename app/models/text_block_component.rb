# frozen_string_literal: true

class TextBlockComponent < ApplicationRecord
  include Discardable
  has_many :text_block_component_pivots
  has_many :text_blocks, through: :text_block_component_pivots
end
