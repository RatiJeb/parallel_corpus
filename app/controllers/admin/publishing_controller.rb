class Admin::PublishingController < Admin::BaseController
  before_action :set_search_params, only: :index
  before_action :require_admin_or_superadmin, only: [:destroy]

  def index
    @publishings = Publishing.all

    %i[name_en name_ka].each do |field|
      unless params[field].blank?
        @publishings = @publishings.where(Publishing.arel_table[field].matches("%#{params[field]}%"))
      end
    end
    @publishings = @publishings.where(id: params[:id]) unless params[:id].blank?
    @publishings = @publishings.order(:name_ka).page(params[:page]).per(20)
  end

  def new
    @publishing = Publishing.new
  end

  def create
    @publishing = Publishing.new(publishing_params)
    if @publishing.save
      redirect_to admin_publishings_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @publishing = Publishing.find(params[:id])
  end

  def update
    @publishing = Publishing.find(params[:id])
    if @publishing.update(publishing_params)
      redirect_to admin_publishings_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @publishing = Publishing.find(params[:id])
    if @publishing.destroy!
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  private

  def set_search_params
    @search = Search::Publishing.new(params.permit(:id, :name_ka, :name_en))
  end

  def publishing_params
    params.require(:publishing).permit(:name_ka, :name_en)
  end

end
