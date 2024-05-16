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

    @text_block_pairs = @text_block_pairs.order(:original_id).page(params[:page]).per(20)
  end

  private

  def set_search_params
    @search = Search::TextBlockPair.new(params.permit(:query, :termin, :original_language, :year_start, :year_end, :translation_year_start,
                                                      :translation_year_end, supergroup_ids: [], group_ids: [],
                                                      collection_ids: [], type_ids: [], field_ids: [], genre_ids: [], author_ids: [],
                                                      translator_ids: [], publishing_ids: []))
  end

  def search_params
    params.permit(:query)
  end
end
