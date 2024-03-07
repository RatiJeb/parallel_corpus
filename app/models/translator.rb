class Translator < ApplicationRecord
  has_many :collection_translators

  has_many :collections, through: :collection_translators

  enum status: [:active, :inactive, :hidden, :deleted]

end
