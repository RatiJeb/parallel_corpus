class TextBlocksController < ApplicationController
  def index
    @search = Search::TextBlock.new()
  end

  def search
    @text_block_pairs = Views::TextBlockPair
    #.@text_block_pairs = @text_block_pairs.joins(collection: [:types, :authors]).where(types: {id: 7}).where(authors: {id: 198}).search('მოუსვენრად')
    @text_block_pairs = @text_block_pairs.includes(collection: :group).search(params[:query]).order(:original_id).page(params[:page]).per(20)
  end

  def advanced_search
    @text_block_pairs = Views::TextBlockPair

    @text_block_pairs = @text_block_pairs.includes(collection: :group).search(params[:query]).order(:original_id).page(params[:page]).per(20)
  end

  private

  def search_params
    params.permit(:query)
  end
end
