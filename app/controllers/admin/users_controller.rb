class Admin::UsersController < Admin::BaseController
  before_action :set_search_params, only: :index

  def index
    @users = User.all
    @users = @users.where(User.arel_table[:email].matches("%#{params[:email]}%")) unless params[:email].blank?
    @users = @users.where(id: params[:id]) unless params[:id].blank?
    @users = @users.order(:email).page(params[:page]).per(20)
  end

  private

  def set_search_params
    @search = Search::User.new(params.permit(:id, :email, :role))
  end
end
