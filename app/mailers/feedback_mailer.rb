# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  def send_feedback_to_admins(feedback_id)
    @feedback = Feedback.find(feedback_id)
    @visitor = "#{@feedback.first_name} #{@feedback.last_name}"
    to = User.admin.or(User.superadmin).pluck(:email)
    subject = I18n.t('feedback_mailer.feedback.subject', visitor: @visitor, subject: @feedback.subject)
    mail to:, subject:
  end
end
