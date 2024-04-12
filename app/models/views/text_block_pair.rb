module Views
  class TextBlockPair < ApplicationRecord
    belongs_to :collection

    enum original_language: [:ka, :en], _prefix: :original_language

    def readonly?
      true
    end
  end
end
