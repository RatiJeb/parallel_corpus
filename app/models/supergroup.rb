class Supergroup < ApplicationRecord

  has_many :groups
  has_many :collections, through: :groups
  has_many :text_blocks, through: :collections

  enum status: [:active, :inactive]

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= :active
  end

end
