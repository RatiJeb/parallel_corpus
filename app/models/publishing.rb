class Publishing < ApplicationRecord
  include Statusable
  has_many :collection_publishings

  has_many :collections, through: :collection_publishings

end
