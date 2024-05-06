class Collection < ApplicationRecord
  include Statusable
  include Discardable

  belongs_to :group
  has_one :supergroup, through: :group
  has_many :text_blocks, dependent: :destroy

  has_many :collection_authors, dependent: :destroy
  has_many :collection_fields, dependent: :destroy
  has_many :collection_genres, dependent: :destroy
  has_many :collection_publishings, dependent: :destroy
  has_many :collection_translators, dependent: :destroy
  has_many :collection_types, dependent: :destroy

  has_many :authors, through: :collection_authors
  has_many :fields, through: :collection_fields
  has_many :genres, through: :collection_genres
  has_many :publishings, through: :collection_publishings
  has_many :translators, through: :collection_translators
  has_many :types, through: :collection_types

  enum original_language: [:ka, :en]

  scope :syncable, -> { where(should_unsync: false) }

  after_initialize :set_default_status, if: :new_record?

  before_create :assign_order_number

  validates :name_ka, uniqueness: { scope: :group_id, message: 'სახელი (ka) არაა უნიკალური ამავე ჯგუფში' }
  validates :name_en, uniqueness: { scope: :group_id, message: 'სახელი (en) არაა უნიკალური ამავე ჯგუფში' }
  validates :year, numericality: { only_integer: true, allow_blank: true, message: 'წელი უნდა იყოს რიცვხი' }, inclusion: { in: -> (_collection) { -3000..Date.current.year }, allow_blank: true, message: "წელი უნდა იყოს მეტი -3000-ზე და ნაკლები ან ტოლი წლევანდელ თარიღზე" }
  validates :translation_year, numericality: { only_integer: true, allow_blank: true, message: 'წელი უნდა იყოს რიცვხი' }, inclusion: { in: -> (collection) { (collection.year || 430)..Date.current.year }, allow_blank: true, message: "წელი უნდა იყოს მეტი 430-ზე ან გამოცემის წელზე და ნაკლები ან ტოლი წლევანდელ თარიღზე" }

  def set_default_status
    self.status ||= :active
  end

  def assign_order_number
    self.order_number = group.collections.order(:order_number).last.order_number + 1
  end

  def serialize
    JSON.generate(as_json.merge({ author_ids: author_ids,
                                  field_ids: field_ids,
                                  genre_ids: genre_ids,
                                  publishing_ids: publishing_ids,
                                  translator_ids: translator_ids,
                                  type_ids: type_ids }))
  end
end
