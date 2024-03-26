class Translator < ApplicationRecord
  include Statusable

  has_many :collection_translators
  has_many :collections, through: :collection_translators

  scope :ordered, -> { order(:name_ka) }
end
