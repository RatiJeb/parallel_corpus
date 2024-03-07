class Author < ApplicationRecord
  has_many :collection_authors

  has_many :collections, through: :collection_authors

  enum status: [:active, :inactive, :hidden, :deleted]

end
