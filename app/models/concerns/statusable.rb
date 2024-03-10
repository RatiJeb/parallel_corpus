module Statusable
  extend ActiveSupport::Concern
  included do
    enum status: [:active, :inactive, :hidden, :deleted]
  end
end
