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

  def set_default_status
    self.status ||= :active
  end

end
