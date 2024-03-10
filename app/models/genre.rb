class Genre < ApplicationRecord
  include Statusable

  has_many :collection_genres

  has_many :collections, through: :collection_genres

end
