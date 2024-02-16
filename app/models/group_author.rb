class GroupAuthor < ApplicationRecord
  belongs_to :group
  belongs_to :author
end
