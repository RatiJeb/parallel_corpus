class Admin::FieldsController < Admin::BaseController
  before_action :set_search_params, only: :index

  def index
    @fields = Field.all

    %i[name_en name_ka].each do |field|
      unless params[field].blank?
        @fields = @fields.where(Field.arel_table[field].matches("%#{params[field]}%"))
      end
    end
    @fields = @fields.where(id: params[:id]) unless params[:id].blank?
    @fields = @fields.order(:name_ka).page(params[:page]).per(20)
  end

  def new
    @field = Field.new
  end

  def create
    @field = Field.new(field_params)
    if @field.save
      redirect_to admin_fields_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @field = Field.find(params[:id])
  end

  def update
    @field = Field.find(params[:id])
    if @field.update(field_params)
      redirect_to admin_fields_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @field = Field.find(params[:id])
    if @field.destroy!
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  private

  def set_search_params
    @search = Search::Field.new(params.permit(:id, :name_ka, :name_en))
  end

  def field_params
    params.require(:field).permit(:name_ka, :name_en)
  end

end
