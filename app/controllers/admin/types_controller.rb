class Admin::TypesController < Admin::BaseController
  before_action :set_search_params, only: :index

  def index
    @types = Type.all

    %i[name_en name_ka].each do |field|
      unless params[field].blank?
        @types = @types.where(Type.arel_table[field].matches("%#{params[field]}%"))
      end
    end
    @types = @types.where(id: params[:id]) unless params[:id].blank?
    @types = @types.order(:name_ka).page(params[:page]).per(20)
  end

  def new
    @type = Type.new
  end

  def create
    @type = Type.new(type_params)
    if @type.save
      redirect_to admin_types_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @type = Type.find(params[:id])
  end

  def update
    @type = Type.find(params[:id])
    if @type.update(type_params)
      redirect_to admin_types_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @type = Type.find(params[:id])
    if @type.destroy!
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  private

  def set_search_params
    @search = Search::Type.new(params.permit(:id, :name_ka, :name_en))
  end

  def type_params
    params.require(:type).permit(:name_ka, :name_en)
  end

end
