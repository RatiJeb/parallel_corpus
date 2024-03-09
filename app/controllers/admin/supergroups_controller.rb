class Admin::SupergroupsController < Admin::BaseController

  def index
    @supergroups = Supergroup.all.order(:id).page(params[:page]).per(20)
  end

  def search
    @supergroups = Supergroup.all
    [:name_ka, :name_en].each do |field|
      if search_params.include?(field)
        @supergroups = @supergroups.where("#{field} LIKE ?", "%#{search_params[field]}%")
      end
    end
    if search_params.include?(:status)
      @supergroups = @supergroups.where(status: search_params[:status])
    end
    @supergroups = @supergroups.order(:id).page(params[:page]).per(20)
    render 'index'
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
    @supergroup = Supergroup.find(params[:id])
    @supergroup.update(supergroup_params)
    @supergroup.save!
    redirect_to admin_supergroups_path
  end

  private

  def search_params
    params.require(:search).permit(:name_ka, :name_en, :status).compact_blank
  end

  def supergroup_params
    params.require(:supergroup).permit(:name_ka, :name_en, :comment, :status)
  end

end
