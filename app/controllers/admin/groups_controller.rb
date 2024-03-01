class Admin::GroupsController < Admin::BaseController

  def index
    if groups_params[:supergroup_id]
      @supergroup = Supergroup.find(groups_params[:supergroup_id])
      @groups = Group.where(supergroup: @supergroup)
    else
      @groups = Group.all
    end
  end

  private

  def groups_params
    params.permit(:supergroup_id)
  end

end
