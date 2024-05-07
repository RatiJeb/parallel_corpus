class User < ApplicationRecord
  include Discardable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [:editor, :admin, :superadmin]

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :editor
  end

  def serialize
    JSON.generate(as_json)
  end
end
