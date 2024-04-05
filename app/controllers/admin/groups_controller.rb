class Admin::GroupsController < Admin::BaseController
  before_action :set_search_params, only: :index
  before_action :require_admin_or_superadmin, only: [:destroy]

  def index

    @supergroup = Supergroup.find(params[:supergroup_id]) unless params[:supergroup_id].blank?

    @groups = Views::GroupDetail.all

    %i[name_en name_ka supergroup_name_ka].each do |field|
      unless params[field].blank?
        @groups = @groups.where(Views::GroupDetail.arel_table[field].matches("%#{params[field]}%"))
      end
    end
    @groups = @groups.where(id: params[:id]) unless params[:id].blank?
    @groups = @groups.where(supergroup_id: params[:supergroup_id]) unless params[:supergroup_id].blank?
    @groups = @groups.where(status: params[:status]) unless params[:status].blank?
    @groups = @groups.order(:id).page(params[:page]).per(20)

    @collections_count = @groups.sum(&:collections_count)
    @text_blocks_count = @groups.sum(&:text_blocks_count)
  end

  def new
    if params[:supergroup_id]
      @supergroup = Supergroup.find(params[:supergroup_id])
      @group = Group.new(supergroup: @supergroup)
    else
      @group = Group.new
    end
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to admin_groups_path(supergroup_id: @group.supergroup.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to admin_groups_path(supergroup_id: @group.supergroup.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy!
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  private

  def require_admin_or_superadmin
    redirect_to(root_url) unless current_user.admin? || current_user.superadmin?
  end

  def set_search_params
    @search = Search::Group.new(params.permit(:id, :supergroup_id, :supergroup_name_ka, :name_ka, :name_en, :status))
  end

  def group_params
    params.require(:group).permit(:supergroup_id, :name_ka, :name_en, :comment, :status, :should_sync)
  end

end
