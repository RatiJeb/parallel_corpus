class TextBlocksController < ApplicationController
  before_action :set_search_params, only: [:advanced_search]

  def index
    @result = CacheService.get('text_blocks_count') || text_blocks_count
  end

  def search
    @text_block_pairs = Views::TextBlockPair
    @text_block_pairs = @text_block_pairs
                          .includes(collection: :group)
                          .search(params[:query])
                          .order(:original_id)
                          .page(params[:page])
                          .per(20)
  end

  def advanced_search

    @text_block_pairs = Views::TextBlockPair
    @text_block_pairs = @text_block_pairs.includes(collection: :group).where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active)).search(params[:query], params[:exact_match].to_s != '0', params[:termin].to_s != "0")

    if params[:original_language].present? && params[:original_language] != 'both'
      @text_block_pairs = @text_block_pairs.where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active), original_language: params[:original_language] == 'ka' ? 0 : 1)
    end

    @text_block_pairs = @text_block_pairs.where(collection: { year: params[:year_start]..params[:year_end] }) if params[:year_start].present? || params[:year_end].present?
    @text_block_pairs = @text_block_pairs.where(collection: { translation_year: params[:translation_year_start]..params[:translation_year_end] }) if params[:translation_year_start].present? || params[:translation_year_end].present?

    if params[:search_text_block_pair].present?
      @text_block_pairs = @text_block_pairs.where(collections: { groups: { supergroup_id: params[:search_text_block_pair][:supergroup_ids] } }) if params[:search_text_block_pair][:supergroup_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: { group_id: params[:search_text_block_pair][:group_ids] }) if params[:search_text_block_pair][:group_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection_id: params[:search_text_block_pair][:collection_ids]) if params[:search_text_block_pair][:collection_ids]&.any?(&:present?)

      @text_block_pairs = @text_block_pairs.where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active).matching_authors(params[:search_text_block_pair][:author_ids])) if params[:search_text_block_pair][:author_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active).matching_fields(params[:search_text_block_pair][:field_ids])) if params[:search_text_block_pair][:field_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active).matching_genres(params[:search_text_block_pair][:genre_ids])) if params[:search_text_block_pair][:genre_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active).matching_publishings(params[:search_text_block_pair][:publishing_ids])) if params[:search_text_block_pair][:publishing_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active).matching_translators(params[:search_text_block_pair][:translator_ids])) if params[:search_text_block_pair][:translator_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.where(group: Group.where(supergroup: Supergroup.where(status: :active), status: :active), status: :active).matching_types(params[:search_text_block_pair][:type_ids])) if params[:search_text_block_pair][:type_ids]&.any?(&:present?)
    end

    @text_block_pairs = @text_block_pairs.order(:original_id).page(params[:page]).per(20)
  end

  private

  def set_search_params
    @search = Search::TextBlockPair.new(params.permit(:query, :termin, :exact_match, :original_language, :year_start, :year_end, :translation_year_start,
                                                      :translation_year_end, search_text_block_pair: { supergroup_ids: [], group_ids: [],
                                                                                                       collection_ids: [], type_ids: [], field_ids: [], genre_ids: [], author_ids: [],
                                                                                                       translator_ids: [], publishing_ids: [] }))
  end

  def search_params
    params.permit(:query)
  end

  def text_blocks_count
    value = {
      pairs: ::NumbersFormattingService.call(
        TextBlock.where(
          collection_id: Collection.where(
            status: :active,
            group_id: Group.where(
              status: :active,
              supergroup_id: Supergroup.where(status: :active)
                                       .pluck(:id),
            ).pluck(:id),
          ),
        ).group(:language).count.min.last,
      ),
      collections: ::NumbersFormattingService.call(
        Collection.where(
          status: :active,
          group_id: Group.where(
            status: :active,
            supergroup_id: Supergroup.where(status: :active).pluck(:id),
          ).pluck(:id)).count,
      ),
      groups: ::NumbersFormattingService.call(Group.where(status: :active,
                                                          supergroup_id: Supergroup.where(status: :active)
                                                                                   .pluck(:id)).count),
      words: TextBlock.word_count_by_language,
    }
    CacheService.set('text_blocks_count', value, DateTime.current + 2.hours)
    value
  end
end
