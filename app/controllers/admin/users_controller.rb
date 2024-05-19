class Admin::UsersController < Admin::BaseController
  before_action :set_search_params, only: :index
  before_action :require_superadmin

  def index
    @users = User.all
    @users = @users.where(User.arel_table[:email].matches("%#{params[:email]}%")) unless params[:email].blank?
    @users = @users.where(id: params[:id]) unless params[:id].blank?
    @users = @users.order(:email).page(params[:page]).per(20)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy!
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  private

  def set_search_params
    @search = Search::User.new(params.permit(:id, :email, :role))
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
