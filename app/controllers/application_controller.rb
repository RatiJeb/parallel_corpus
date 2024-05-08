class ApplicationController < ActionController::Base
  protected

  def require_admin_or_superadmin
    redirect_to(root_url) unless current_user.admin? || current_user.superadmin?
  end

  def authenticate_inviter!
    return redirect_to root_path unless current_user.blank? || current_user.superadmin?
    super
  end
end
