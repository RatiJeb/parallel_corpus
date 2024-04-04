class Field < ApplicationRecord
  include Statusable

  has_many :collection_fields, dependent: :destroy
  has_many :collections, through: :collection_fields

  scope :ordered, -> { order(:name_ka) }
end
