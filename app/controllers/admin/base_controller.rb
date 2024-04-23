class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :require_admin

  def require_admin
    redirect_to new_user_session_path unless current_user
  end

  def require_admin_or_superadmin
    redirect_to(root_url) unless current_user.admin? || current_user.superadmin?
  end
end
