# frozen_string_literal: true
module Admin
  class BaseController < ApplicationController
    layout 'admin'
    before_action :require_admin

    def require_admin
      redirect_to new_user_session_path unless current_user
    end
  end
end
