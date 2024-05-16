module Views
  class TextBlockPair < ApplicationRecord
    belongs_to :collection

    enum original_language: [:ka, :en], _prefix: :original_language

    scope :search, ->(query, termin=false) { where(
      Views::TextBlockPair.arel_table[:original_contents].matches_regexp(
        "(^|[^a-zA-Z0-9ა-ჰ-])#{termin ? '\[t\]' : ''}#{query}#{termin ? '\[\/t\]' : ''}($|[^a-zA-Z0-9ა-ჰ-])",
        case_sensitive = false)) }

    def readonly?
      true
    end
  end
end
