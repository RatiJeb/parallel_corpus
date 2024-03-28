class Group < ApplicationRecord
  include Statusable

  belongs_to :supergroup
  has_many :collections
  has_many :text_blocks, through: :collections

  has_many :synced_collections, -> { syncable }, class_name: 'Collection'

  has_many :authors, -> { distinct }, through: :synced_collections
  has_many :fields, -> { distinct }, through: :synced_collections
  has_many :genres, -> { distinct }, through: :synced_collections
  has_many :publishings, -> { distinct }, through: :synced_collections
  has_many :translators, -> { distinct }, through: :synced_collections
  has_many :types, -> { distinct }, through: :synced_collections

  scope :syncable, -> { where(should_sync: true) }

  scope :ordered, -> { order(:name_ka) }

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= :active
  end

end
