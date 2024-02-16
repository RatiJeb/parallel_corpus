class CollectionAuthor < ApplicationRecord
  belongs_to :collection
  belongs_to :author
end
