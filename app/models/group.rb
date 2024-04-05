class Group < ApplicationRecord
  include Statusable

  belongs_to :supergroup
  has_many :collections, dependent: :destroy
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

  validates :name_ka, uniqueness: { scope: :supergroup_id, message: 'სახელი (ka) არაა უნიკალური ამავე ქვეკორპუსში' }
  validates :name_en, uniqueness: { scope: :supergroup_id, message: 'სახელი (en) არაა უნიკალური ამავე ქვეკორპუსში' }

  def set_default_status
    self.status ||= :active
  end

end
