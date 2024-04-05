class Translator < ApplicationRecord
  include Statusable

  has_many :collection_translators, dependent: :destroy
  has_many :collections, through: :collection_translators

  scope :ordered, -> { order(:name_ka) }

  validates :name_ka, uniqueness: { message: 'სახელი (ka) არაა უნიკალური' }
  validates :name_en, uniqueness: { message: 'სახელი (en) არაა უნიკალური' }
  
end
