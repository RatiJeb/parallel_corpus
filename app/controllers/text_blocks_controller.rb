class TextBlocksController < ApplicationController
  before_action :set_search_params, only: [:advanced_search]

  def search
    @text_block_pairs = Views::TextBlockPair
    #.@text_block_pairs = @text_block_pairs.joins(collection: [:types, :authors]).where(types: {id: 7}).where(authors: {id: 198}).search('მოუსვენრად')
    @text_block_pairs = @text_block_pairs.includes(collection: :group).search(params[:query]).order(:original_id).page(params[:page]).per(20)
  end

  def advanced_search

    @text_block_pairs = Views::TextBlockPair
    @text_block_pairs = @text_block_pairs.includes(collection: :group).search(params[:query], params[:termin].present? && params[:termin] != "0")

    if params[:original_language].present? && params[:original_language] != 'both'
      @text_block_pairs = @text_block_pairs.where(original_language: params[:original_language] == 'ka' ? 0 : 1)
    end

    @text_block_pairs = @text_block_pairs.where(collection: { year: params[:year_start]&.to_i..params[:years_end]&.to_i })
    @text_block_pairs = @text_block_pairs.where(collection: { translation_year: params[:translation_year_start]&.to_i..params[:translation_year_end]&.to_i })

    if params[:search_text_block_pair].present?
      @text_block_pairs = @text_block_pairs.where(collections: { groups: { supergroup_id: params[:search_text_block_pair][:supergroup_ids] } }) if params[:search_text_block_pair][:supergroup_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: { group_id: params[:search_text_block_pair][:group_ids] }) if params[:search_text_block_pair][:group_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection_id: params[:search_text_block_pair][:collection_ids]) if params[:search_text_block_pair][:collection_ids]&.any?(&:present?)

      @text_block_pairs = @text_block_pairs.where(collection: Collection.matching_authors(params[:search_text_block_pair][:author_ids])) if params[:search_text_block_pair][:author_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.matching_fields(params[:search_text_block_pair][:field_ids])) if params[:search_text_block_pair][:field_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.matching_genres(params[:search_text_block_pair][:genre_ids])) if params[:search_text_block_pair][:genre_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.matching_publishings(params[:search_text_block_pair][:publishing_ids])) if params[:search_text_block_pair][:publishing_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.matching_translators(params[:search_text_block_pair][:translator_ids])) if params[:search_text_block_pair][:translator_ids]&.any?(&:present?)
      @text_block_pairs = @text_block_pairs.where(collection: Collection.matching_types(params[:search_text_block_pair][:type_ids])) if params[:search_text_block_pair][:type_ids]&.any?(&:present?)
    end

    @text_block_pairs = @text_block_pairs.order(:original_id).page(params[:page]).per(20)
  end

  private

  def set_search_params
    @search = Search::TextBlockPair.new(params.permit(:query, :termin, :original_language, :year_start, :year_end, :translation_year_start,
                                                      :translation_year_end, search_text_block_pair: { supergroup_ids: [], group_ids: [],
                                                      collection_ids: [], type_ids: [], field_ids: [], genre_ids: [], author_ids: [],
                                                      translator_ids: [], publishing_ids: [] }))
  end

  def search_params
    params.permit(:query)
  end
end
