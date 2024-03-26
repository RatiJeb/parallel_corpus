class Type < ApplicationRecord
  include Statusable

  has_many :collection_types
  has_many :collections, through: :collection_types

  scope :ordered, -> { order(:name_ka) }
end
