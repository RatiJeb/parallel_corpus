class Admin::CollectionsController < Admin::BaseController

  def index
    if collections_params[:group_id]
      @group = Group.find(collections_params[:group_id])
      @collections = Collection.where(group: @group)
    else
      @collections = collections_params.all
    end
  end

  private

  def collections_params
    params.permit(:group_id)
  end

end
