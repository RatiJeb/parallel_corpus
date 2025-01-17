class ContactsController < ApplicationController
  def index
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.create(contact_params)
  end

  private

  def contact_params
    params.require(:feedback).permit(:first_name, :last_name, :email, :subject, :content)
  end
end
