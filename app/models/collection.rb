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
  scope :ordered, -> { order(:order_number) }

  scope :matching_authors, -> (author_ids){ where(collection_authors: CollectionAuthor.where(author_id: author_ids)) }
  scope :matching_fields, -> (field_ids){ where(collection_fields: CollectionField.where(field_id: field_ids)) }
  scope :matching_genres, -> (genre_ids){ where(collection_genres: CollectionGenre.where(genre_id: genre_ids)) }
  scope :matching_publishings, -> (publishing_ids){ where(collection_publishings: CollectionPublishing.where(publishing_id: publishing_ids)) }
  scope :matching_translators, -> (translator_ids){ where(collection_translators: CollectionTranslator.where(translator_id: translator_ids)) }
  scope :matching_types, -> (type_ids){ where(collection_types: CollectionType.where(type_id: type_ids)) }

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
    if group.collections.any?
      self.order_number = group.collections.order(:order_number).last.order_number + 1
    else
      self.order_number = 0
    end
  end

  def serialize
    JSON.generate(as_json.merge({ author_ids:,
                                  field_ids:,
                                  genre_ids:,
                                  publishing_ids:,
                                  translator_ids:,
                                  type_ids: }))
  end
end
