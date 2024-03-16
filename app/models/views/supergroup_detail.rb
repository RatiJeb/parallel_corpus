module Views
  class SupergroupDetail < ApplicationRecord
    include Statusable

    def readonly?
      true
    end
  end
end
