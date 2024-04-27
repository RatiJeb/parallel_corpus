module Views
  class TextBlockPair < ApplicationRecord
    belongs_to :collection

    enum original_language: [:ka, :en], _prefix: :original_language

    scope :search, ->(query) { where(Views::TextBlockPair.arel_table[:original_contents].matches("%#{query}%")) }

    def readonly?
      true
    end
  end
end
