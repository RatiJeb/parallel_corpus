class Admin::CollectionsController < Admin::BaseController

  def index
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @collections = Collection.where(group: @group).order(created_at: :asc)
    else
      @collections = Collection.all.order(created_at: :desc)
    end
  end

  def new
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @collection = Collection.new(group: @group, author_ids: @group.author_ids)
    else
      @collection = Collection.new
    end
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.save!
    redirect_to admin_collections_path(group_id: @collection.group.id)
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def update
    @collection = Collection.find(params[:id])

    collection_params.delete(:author_ids) if @collection.pwichka?
    @collection.update(collection_params)
    @collection.save!
    redirect_to admin_collections_path(group_id: @collection.group.id)
  end

  private

  def collection_params
    params.require(:collection).permit(
      :group_id, :name_ka, :name_en, :comment, :status, :additional_info,
      :year, :translation_year, :original_language, author_ids: [],
      genre_ids: [], field_ids: [], type_ids: [], publishing_ids: []
    )
  end

end
