class Collection < ApplicationRecord
  include Statusable

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

  validates :name_ka, uniqueness: { scope: :group_id, message: 'სახელი (ka) არაა უნიკალური ამავე ჯგუფში' }
  validates :name_en, uniqueness: { scope: :group_id, message: 'სახელი (en) არაა უნიკალური ამავე ჯგუფში' }
  validates :year, numericality: { only_integer: true, allow_blank: true, message: 'წელი უნდა იყოს რიცვხი' }, inclusion: { in: -> (_collection) { 430..Date.current.year }, allow_blank: true, message: "წელი უნდა იყოს მეტი 430-ზე და ნაკლები ან ტოლი წლევანდელ თარიღზე" }
  validates :translation_year, numericality: { only_integer: true, allow_blank: true, message: 'წელი უნდა იყოს რიცვხი' }, inclusion: { in: -> (collection) { (collection.year || 430)..Date.current.year }, allow_blank: true, message: "წელი უნდა იყოს მეტი 430-ზე ან გამოცემის წელზე და ნაკლები ან ტოლი წლევანდელ თარიღზე" }

  def set_default_status
    self.status ||= :active
  end

end
