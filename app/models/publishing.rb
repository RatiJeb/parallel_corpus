class Publishing < ApplicationRecord
  has_many :group_publishings
  has_many :collection_publishings

  has_many :groups, through: :group_publishings
  has_many :collections, through: :collection_publishings
  
end
