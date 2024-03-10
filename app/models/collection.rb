class Collection < ApplicationRecord
  include Statusable

  belongs_to :group
  has_one :supergroup, through: :group
  has_many :text_blocks

  has_many :collection_authors
  has_many :collection_fields
  has_many :collection_genres
  has_many :collection_publishings
  has_many :collection_translators
  has_many :collection_types

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
