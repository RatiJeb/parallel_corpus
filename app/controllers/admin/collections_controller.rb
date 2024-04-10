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
                                        type_ids: @group.type_ids,

                                        year: @group.synced_collections.first.year,
                                        translation_year: @group.synced_collections.first.translation_year,
                                        original_language: @group.synced_collections.first.original_language
                                      })
      end
    else
      @collection = Collection.new
    end
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @collection = Collection.new(collection_params)
        validations_passed = @collection.save

        if validations_passed
          sync_other_collections
          redirect_to admin_collections_path(group_id: @collection.group.id)
        else
          render :new, status: :unprocessable_entity
        end
      end
    rescue => e
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @collection = Collection.find(params[:id])
        validations_passed = @collection.update(collection_params)

        if validations_passed
          sync_other_collections
          redirect_to admin_collections_path(group_id: @collection.group.id)
        else
          render :edit, status: :unprocessable_entity
        end
      end
    rescue => e
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

  def new_text_blocks
    @collection = Collection.find(params[:id])
  end

  def create_text_blocks
    @collection = Collection.find(params[:id])

    [:ka, :en].each do |language|
      sentences = text_blocks_params[language].scan(/[^\.!?]+[\.!?]+|[^\.!?]+.\z/).map(&:strip)
      sentences.each_with_index do |sentence, index|
        TextBlock.create(collection: @collection,
                         contents: sentence,
                         order_number: index,
                         language: language
                        )
      end
    end

    redirect_to edit_text_blocks_admin_collection_path(id: @collection.id)
  end

  def edit_text_blocks
    @collection = Collection.find(params[:id])
  end

  private

  def sync_other_collections
    if !@collection.should_unsync? && @collection.group.should_sync?
      @collection.group.synced_collections.each do |collection|
        validation_passed_inner = collection.update(author_ids: @collection.author_ids,
                                                    field_ids: @collection.field_ids,
                                                    genre_ids: @collection.genre_ids,
                                                    publishing_ids: @collection.publishing_ids,
                                                    translator_ids: @collection.translator_ids,
                                                    type_ids: @collection.type_ids,

                                                    year: @collection.year,
                                                    translation_year: @collection.translation_year,
                                                    original_language: @collection.original_language
                                                  )
        unless validation_passed_inner
          raise ActiveRecord::Rollback
        end
      end
    end
  end

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

  def text_blocks_params
    params.require(:collection).permit(:ka, :en)
  end
end
