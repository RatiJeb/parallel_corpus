class Translator < ApplicationRecord
  has_many :group_translators
  has_many :collection_translators

  has_many :groups, through: :group_translators
  has_many :collections, through: :collection_translators
end
