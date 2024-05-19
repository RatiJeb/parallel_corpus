class User < ApplicationRecord
  include Discardable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :validatable

  enum role: [:editor, :admin, :superadmin]

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :editor
  end

  def serialize
    JSON.generate(as_json)
  end

  def invitation_pending?
    created_by_invite? && !invitation_accepted?
  end

  def status
    if created_by_invite?
      if invitation_accepted?
        :active
      else
        :pending
      end
    else
      :active
    end
  end
end
