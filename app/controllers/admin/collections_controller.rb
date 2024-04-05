class Admin::CollectionsController < Admin::BaseController
  before_action :set_search_params, only: :index
  before_action :require_admin_or_superadmin, only: [:destroy]

  def index
    @group = Group.find(params[:group_id]) unless params[:group_id].blank?

    @collections = Views::CollectionDetail.all

    %i[name_en name_ka group_name_ka supergroup_name_ka].each do |field|
      unless params[field].blank?
        @collections = @collections.where(Views::CollectionDetail.arel_table[field].matches("%#{params[field]}%"))
      end
    end
    @collections = @collections.where(id: params[:id]) unless params[:id].blank?
    @collections = @collections.where(group_id: params[:group_id]) unless params[:group_id].blank?
    @collections = @collections.where(status: params[:status]) unless params[:status].blank?
    @collections = @collections.order(:id).page(params[:page]).per(20)

    @text_blocks_count = @collections.sum(&:text_blocks_count)
  end

  def new
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @collection = Collection.new(group: @group)
      if @group.should_sync?
        @collection.assign_attributes({ author_ids: @group.author_ids,
                                        field_ids: @group.field_ids,
                                        genre_ids: @group.genre_ids,
                                        publishing_ids: @group.publishing_ids,
                                        translator_ids: @group.translator_ids,
                                        type_ids: @group.type_ids })
      end
    else
      @collection = Collection.new
    end
  end

  def create
    @collection = Collection.new(collection_params)

    if @collection.save
      redirect_to admin_collections_path(group_id: @collection.group.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def update
    @collection = Collection.find(params[:id])
    
    if @collection.update(collection_params)
      redirect_to admin_collections_path(group_id: @collection.group.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @collection = Collection.find(params[:id])
    if @collection.destroy!
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  private

  def require_admin_or_superadmin
    redirect_to(root_url) unless current_user.admin? || current_user.superadmin?
  end

  def set_search_params
    @search = Search::Collection.new(params.permit(:id, :supergroup_name_ka, :group_id, :group_name_ka, :name_ka, :name_en, :status))
  end

  def collection_params
    params.require(:collection).permit(
      :group_id, :name_ka, :name_en, :comment, :status, :additional_info, :should_unsync,
      :year, :translation_year, :original_language, author_ids: [], translator_ids: [],
      genre_ids: [], field_ids: [], type_ids: [], publishing_ids: []
    )
  end
end
