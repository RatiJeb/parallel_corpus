class Field < ApplicationRecord
  has_many :group_fields
  has_many :collection_fields

  has_many :groups, through: :group_fields
  has_many :collections, through: :collection_fields

  enum status: [:active, :inactive, :hidden, :deleted]
  
end
