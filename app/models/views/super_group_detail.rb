module Views
  class SuperGroupDetail < ApplicationRecord
    include Statusable
    
    def readonly?
      true
    end
  end
end
