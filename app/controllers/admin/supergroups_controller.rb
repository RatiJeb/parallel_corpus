class Admin::SupergroupsController < Admin::BaseController
  before_action :set_search_params, only: :index

  def index
    @supergroups = Views::SupergroupDetail.all
    %i[name_en name_ka].each do |field|
      unless params[field].blank?
        @supergroups = @supergroups.where(Views::SupergroupDetail.arel_table[field].matches("%#{params[field]}%"))
      end
    end
    @supergroups = @supergroups.where(id: params[:id]) unless params[:id].blank?
    @supergroups = @supergroups.where(status: params[:status]) unless params[:status].blank?
    @supergroups = @supergroups.order(:id).page(params[:page]).per(20)

    @groups_count = @supergroups.sum(&:groups_count)
    @collections_count = @supergroups.sum(&:collections_count)
    @text_blocks_count = @supergroups.sum(&:text_blocks_count)/2
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

  def destroy
    @supergroup = Supergroup.find(params[:id])
    if @supergroup.destroy!
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  private

  def set_search_params
    @search = Search::Supergroup.new(params.permit(:id, :name_ka, :name_en, :status))
  end

  def supergroup_params
    params.permit(:name_ka, :name_en, :comment, :status)
  end

end
