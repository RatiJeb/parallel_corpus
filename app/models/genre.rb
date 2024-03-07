class Genre < ApplicationRecord
  has_many :collection_genres

  has_many :collections, through: :collection_genres

  enum status: [:active, :inactive, :hidden, :deleted]

end
