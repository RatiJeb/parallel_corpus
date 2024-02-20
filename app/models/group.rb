class Group < ApplicationRecord

  belongs_to :supergroup
  has_many :collections
  has_many :text_blocks, through: :collections

  has_many :group_authors
  has_many :group_fields
  has_many :group_genres
  has_many :group_publishings
  has_many :group_translators
  has_many :group_types

  has_many :authors, through: :group_authors
  has_many :fields, through: :group_fields
  has_many :genres, through: :group_genres
  has_many :publishings, through: :group_publishings
  has_many :translators, through: :group_translators
  has_many :types, through: :group_types

  enum original_language: [:ka, :en]
  enum status: [:active, :inactive, :hidden, :deleted]

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= :active
  end

end
