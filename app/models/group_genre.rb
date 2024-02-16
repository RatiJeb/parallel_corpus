class GroupGenre < ApplicationRecord
  belongs_to :group
  belongs_to :genre
end
