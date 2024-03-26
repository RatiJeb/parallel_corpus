class Genre < ApplicationRecord
  include Statusable

  has_many :collection_genres
  has_many :collections, through: :collection_genres

  scope :ordered, -> { order(:name_ka) }
end
