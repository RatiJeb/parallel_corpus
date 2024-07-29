# frozen_string_literal: false

# Application Service
class NumbersFormattingService < ApplicationService
  def self.call(number, delimiter = ' ', split_num = 3)
    number.to_s.reverse.scan(/.{1,#{split_num}}/).join(delimiter).reverse
  end
end
