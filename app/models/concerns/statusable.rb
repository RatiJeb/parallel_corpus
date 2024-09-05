module Statusable
  extend ActiveSupport::Concern
  included do
    enum status: [:active, :hidden, :deleted]
  end
end
