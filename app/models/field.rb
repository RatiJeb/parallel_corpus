class Field < ApplicationRecord
  include Statusable

  has_many :collection_fields

  has_many :collections, through: :collection_fields

end
