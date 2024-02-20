class Type < ApplicationRecord
  has_many :group_types
  has_many :collection_types

  has_many :groups, through: :group_types
  has_many :collections, through: :collection_types

  enum status: [:active, :inactive, :hidden, :deleted]
  
end
