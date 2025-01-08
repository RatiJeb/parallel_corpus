# frozen_string_literal: true

class TextBlockComponentPivot < ApplicationRecord
  belongs_to :text_block
  belongs_to :text_block_component
end
