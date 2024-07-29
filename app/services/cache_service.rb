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

    JSON.parse(cache[:value])
  end

  def self.del(key)
    Rails.cache.delete(key)
  end
end
