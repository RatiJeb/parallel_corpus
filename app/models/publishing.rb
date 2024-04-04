class Publishing < ApplicationRecord
  include Statusable

  has_many :collection_publishings, dependent: :destroy
  has_many :collections, through: :collection_publishings

  scope :ordered, -> { order(:name_ka) }
end
