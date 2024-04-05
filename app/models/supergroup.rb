class Supergroup < ApplicationRecord
  include Statusable

  has_many :groups, dependent: :destroy
  has_many :collections, through: :groups
  has_many :text_blocks, through: :collections

  after_initialize :set_default_status, if: :new_record?

  validates :name_ka, uniqueness: { message: 'სახელი (ka) არაა უნიკალური' }
  validates :name_en, uniqueness: { message: 'სახელი (en) არაა უნიკალური' }

  def set_default_status
    self.status ||= :active
  end

end
