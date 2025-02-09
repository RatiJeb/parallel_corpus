class ApplicationController < ActionController::Base
  before_action :set_locale

  protected

  def set_locale
    I18n.locale = params[:locale] if params[:locale]
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      admin_root_path
    else
      super
    end
  end

  def require_admin_or_superadmin
    redirect_to(root_url) unless current_user.admin? || current_user.superadmin?
  end

  def require_superadmin
    redirect_to(root_url) unless current_user.superadmin?
  end

  def authenticate_inviter!
    return redirect_to root_path unless current_user.blank? || current_user.superadmin?
    super
  end
end
