class Admin::SupergroupsController < Admin::BaseController

  def index
    @supergroups = Supergroup.all
  end

  def new
    @supergroup = Supergroup.new
  end

  def create
    @supergroup = Supergroup.new(supergroup_params)
    @supergroup.save!
    redirect_to admin_supergroups_path
  end

  def edit
    @supergroup = Supergroup.find(params[:id])
  end

  def update
    @supergroup = Supergroup.update(supergroup_params)
    @supergroup.save!
    redirect_to admin_supergroups_path
  end

  private

  def supergroup_params
    params.require(:supergroup).permit(:name_ka, :name_en, :comment, :status)
  end

end
