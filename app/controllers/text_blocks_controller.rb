class TextBlocksController < ApplicationController
  def index
  end

  def search
    @text_blocks = TextBlock.simple_search(search_params[:query])
  end

  private

  def search_params
    params.permit(:query)
  end
end