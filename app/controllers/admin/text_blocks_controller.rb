class Admin::TextBlocksController < Admin::BaseController
  before_action :set_search_params, only: :index

  def index
    @collection = Collection.find(params[:collection_id]) unless params[:collection_id].blank?

    @text_blocks = Views::TextBlockPair.where(original_language: 0)

    %i[original_contents translation_contents].each do |field|
      unless params[field].blank?
        @text_blocks = @text_blocks.where(Views::TextBlockPair.arel_table[field].matches("%#{params[field]}%"))
      end
    end
    @text_blocks = @text_blocks.where(original_id: params[:original_id]) unless params[:original_id].blank?
    @text_blocks = @text_blocks.where(collection_id: params[:collection_id]) unless params[:collection_id].blank?
    @text_blocks = @text_blocks.order(:original_id).page(params[:page]).per(20)
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

    # collection_params.delete(:author_ids) if @collection.pwichka?
    @collection.update(collection_params)
    @collection.save!
    redirect_to admin_collections_path(group_id: @collection.group.id)
  end

  private

  def set_search_params
    @search = Search::TextBlock.new(params.permit(:original_id, :original_contents, :translation_contents))
  end

end
