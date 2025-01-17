module Views
  class TextBlockPair < ApplicationRecord
    belongs_to :collection

    enum original_language: { ka: 0, en: 1 }, _prefix: :original_language

    scope :search, lambda { |query, exact_match = false, termin = false|
      query = "\[t\]#{query}\[\/t\]" if termin
      query = "(^|[^a-zA-Z0-9ა-ჰ-])#{query}($|[^a-zA-Z0-9ა-ჰ-])" if exact_match
      where(
        Views::TextBlockPair
          .arel_table[:original_contents]
          .matches_regexp(
            query,
            false,
          ),
      ).or(
        where(
          Views::TextBlockPair
            .arel_table[:translation_contents]
            .matches_regexp(
              query,
              false,
            ),
        ),
      )
    }

    def readonly?
      true
    end
  end
end
