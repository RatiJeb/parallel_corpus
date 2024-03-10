module Views
  class GroupDetail < ApplicationRecord
    include Statusable
    
    def readonly?
      true
    end
  end
end
