# frozen_string_literal: false

# Application Service
class CacheService < ApplicationService
  def self.set(key, value, expires_in = nil)
    Rails.cache.write(key.to_s, { value: value.to_json, expires_in: })
  end

  def self.get(key)
    cache = Rails.cache.read(key.to_s)
    return if cache.blank?

    del(key) && return if cache[:expires_in] && cache[:expires_in] < DateTime.current

    result = JSON.parse(cache[:value])
    case
    when result&.class == Hash
      result.deep_symbolize_keys
    when result&.class == Array
      result.map(&:deep_symbolize_keys)
    else
      result
    end
  end

  def self.del(key)
    Rails.cache.delete(key)
  end
end
