class Author < ApplicationRecord
  include Statusable
  include Discardable

  has_many :collection_authors, dependent: :destroy
  has_many :collections, through: :collection_authors

  scope :ordered, -> { order(:name_ka) }

  validates :name_ka, uniqueness: { message: 'სახელი (ka) არაა უნიკალური' }
  validates :name_en, uniqueness: { message: 'სახელი (en) არაა უნიკალური' }

  def serialize
    JSON.generate(as_json.merge({ collection_ids: collection_ids }))
  end
end
