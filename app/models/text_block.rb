class TextBlock < ApplicationRecord
  belongs_to :collection

  enum language: [:ka, :en]

end
