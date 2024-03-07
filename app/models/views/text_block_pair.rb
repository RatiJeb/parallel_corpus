module Views
  class TextBlockPair < ApplicationRecord
    belongs_to :collection

    def readonly?
      true
    end
  end
end
