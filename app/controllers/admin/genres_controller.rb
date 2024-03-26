class Admin::GenresController < Admin::BaseController
  before_action :set_search_params, only: :index

  def index
    @genres = Genre.all

    %i[name_en name_ka].each do |field|
      unless params[field].blank?
        @genres = @genres.where(Genre.arel_table[field].matches("%#{params[field]}%"))
      end
    end
    @genres = @genres.where(id: params[:id]) unless params[:id].blank?
    @genres = @genres.order(:name_ka).page(params[:page]).per(20)
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    @genre.save!
    redirect_to admin_genres_path
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    @genre.update(genre_params)
    @genre.save!
    redirect_to admin_genres_path
  end

  def destroy
    @genre = Genre.find(params[:id])
    if @genre.destroy!
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  private

  def set_search_params
    @search = Search::Genre.new(params.permit(:id, :name_ka, :name_en))
  end

  def genre_params
    params.require(:genre).permit(:name_ka, :name_en)
  end

end
