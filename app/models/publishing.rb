class Publishing < ApplicationRecord
  has_many :collection_publishings

  has_many :collections, through: :collection_publishings

  enum status: [:active, :inactive, :hidden, :deleted]

end
