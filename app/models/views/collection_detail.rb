module Views
  class CollectionDetail < ApplicationRecord
    include Statusable

    def readonly?
      true
    end
  end
end
