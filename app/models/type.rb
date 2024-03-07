class Type < ApplicationRecord
  has_many :collection_types

  has_many :collections, through: :collection_types

  enum status: [:active, :inactive, :hidden, :deleted]

end
