module Statusable
  extend ActiveSupport::Concern
  included do
    enum status: [:active, :hidden]
  end
end
