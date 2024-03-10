class Author < ApplicationRecord
  include Statusable
  
  has_many :collection_authors

  has_many :collections, through: :collection_authors

end
