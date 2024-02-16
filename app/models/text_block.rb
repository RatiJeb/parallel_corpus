class TextBlock < ApplicationRecord
  belongs_to :collection
  belongs_to :group, through: :collection
  belongs_to :supergroup, through: :group

  enum language: [:ka, :en]

end
