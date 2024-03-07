class Field < ApplicationRecord
  has_many :collection_fields

  has_many :collections, through: :collection_fields

  enum status: [:active, :inactive, :hidden, :deleted]

end
