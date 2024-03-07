class Admin::GroupsController < Admin::BaseController

  def index
    if params[:supergroup_id]
      @supergroup = Supergroup.find(params[:supergroup_id])
      @groups = Group.where(supergroup: @supergroup).order(:id).page(params[:page]).per(20)
    else
      @groups = Group.all.order(:id).page(params[:page]).per(20)
    end
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
    @group.save!
    redirect_to admin_groups_path(supergroup_id: @group.supergroup.id)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update(group_params)
    @group.save!
    redirect_to admin_groups_path(supergroup_id: @group.supergroup.id)
  end

  private

  def group_params
    params.require(:group).permit(
      :supergroup_id, :name_ka, :name_en, :comment, :status, :additional_info,
      :year, :translation_year, :original_language, author_ids: [],
      genre_ids: [], field_ids: [], type_ids: [], publishing_ids: []
    )
  end

end
