# frozen_string_literal: true

class Feedback < ApplicationRecord
  validates :subject, :first_name, :last_name, :content, :email, presence: true
  validates :subject, length: { maximum: 255 }
  validates :content, length: { maximum: 10_000 }
  validates :email, length: { maximum: 100 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, length: { maximum: 50 }

  after_create :send_email

  def send_email
    FeedbackMailer.send_feedback_to_admins(id).deliver_later
  end
end
