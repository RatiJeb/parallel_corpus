# frozen_string_literal: true

module Statusable
  extend ActiveSupport::Concern
  included do
    enum status: { active: 0, hidden: 1, deleted: 2 }
  end
end
