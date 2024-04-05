class Genre < ApplicationRecord
  include Statusable

  has_many :collection_genres, dependent: :destroy
  has_many :collections, through: :collection_genres

  scope :ordered, -> { order(:name_ka) }

  validates :name_ka, uniqueness: { scope: :name_en, message: 'ka და en სახელების კომბინაცია არაა უნიკალური' }
  
end
