require 'tempfile'

class Admin::TextBlocksController < Admin::BaseController
  before_action :set_search_params, only: [:index, :edit_multiple]

  def index
    @collection = Collection.find(params[:collection_id]) unless params[:collection_id].blank?

    # @text_blocks = Views::TextBlockPair.where(original_language: 0)

    @text_blocks = TextBlock.all

    # %i[original_contents translation_contents].each do |field|
    #   unless params[field].blank?
    #     @text_blocks = @text_blocks.where(TextBlock.arel_table[field].matches("%#{params[field]}%"))
    #   end
    # end
    @text_blocks = @text_blocks.where(language: :ka).where(TextBlock.arel_table[:contents].matches("%#{params[:original_contents]}%")) unless params[:original_contents].blank?
    @text_blocks = @text_blocks.where(language: :en).where(TextBlock.arel_table[:contents].matches("%#{params[:translation_contents]}%")) unless params[:translation_contents].blank?
    @text_blocks = @text_blocks.where(id: params[:original_id]) unless params[:original_id].blank?
    @text_blocks = @text_blocks.where(collection_id: params[:collection_id]) unless params[:collection_id].blank?
    @text_blocks = @text_blocks.order(:order_number).page(params[:page]).per(40)
  end

  def show
  end

  def new
    @text_block = TextBlock.new
  end

  def create
    last_block = TextBlock.find(params[:last_text_block_id])
    ActiveRecord::Base.transaction do
      next_blocks = TextBlock.where(collection_id: last_block.collection_id)
                             .where(language: last_block.language)
                             .where("order_number > ?", last_block.order_number)
                             .order(order_number: :desc)
      next_blocks.each do |block|
        block.increment!(:order_number, 1)
      end
      @text_block = TextBlock.create!(collection_id: last_block.collection_id,
                        language: last_block.language,
                        order_number: last_block.order_number + 1
                       )
      head(:ok)
    rescue
      render(json: {}, status: :unprocessable_entity)
    end
  end

  def edit
    @text_block = TextBlock.find(params[:id])
  end

  def update
    @text_block = TextBlock.find(params[:id])
    if @text_block.update(text_blocks_params)
      head(:ok)
    else
      render(json: {}, status: :unprocessable_entity)
    end
  end

  def destroy
    @text_block = TextBlock.find(params[:id])
    ActiveRecord::Base.transaction do
      next_blocks = TextBlock.where(collection_id: @text_block.collection_id)
                             .where(language: @text_block.language)
                             .where("order_number > ?", @text_block.order_number)
                             .order(order_number: :asc)
      @text_block.destroy!
      next_blocks.each do |block|
        block.decrement!(:order_number, 1)
      end
      head(:ok)
    rescue
      render(json: {}, status: :unprocessable_entity)
    end
  end

  def edit_multiple
    @collection = Collection.find(params[:collection_id])
    @text_blocks = @collection.text_blocks.order(:order_number).to_a

    @anchored_block = @text_blocks.detect do |tb|
      if params[:order_number].present?
        tb.order_number == params[:order_number].to_i
      elsif params[:original_contents].present?
        tb.ka? && tb.contents&.include?(params[:original_contents])
      elsif params[:translation_contents].present?
        tb.en? && tb.contents&.include?(params[:translation_contents])
      end
    end
  end

  def merge
    @text_block = TextBlock.find(params[:id])
    ActiveRecord::Base.transaction do
      next_blocks = TextBlock.where(collection_id: @text_block.collection_id)
                             .where(language: @text_block.language)
                             .where("order_number > ?", @text_block.order_number)
                             .order(order_number: :asc)
      if next_blocks.first
        @text_block.contents = "#{@text_block.contents} #{next_blocks.first.contents}"
        @text_block.save!
        next_blocks.first.destroy!
      end
      next_blocks.each do |block|
        block.decrement!(:order_number, 1)
      end
      head(:ok)
    rescue
      render(json: {}, status: :unprocessable_entity)
    end
  end

  def swap
    @text_block = TextBlock.find(params[:id])
    ActiveRecord::Base.transaction do
      next_block = TextBlock.where(collection_id: @text_block.collection_id)
                             .where(language: @text_block.language)
                             .where(order_number: @text_block.order_number + 1).first
      if next_block
        @text_block.order_number = -1
        @text_block.save!
        next_block.decrement!(:order_number, 1)
        @text_block.order_number = next_block.order_number + 1
        @text_block.save!
      end
      head(:ok)
    rescue
      render(json: {}, status: :unprocessable_entity)
    end
  end

  def split
    @text_block = TextBlock.find(params[:id])
    ActiveRecord::Base.transaction do
      next_blocks = TextBlock.where(collection_id: @text_block.collection_id)
                             .where(language: @text_block.language)
                             .where("order_number > ?", @text_block.order_number)
                             .order(order_number: :desc)
      next_blocks.each do |block|
        block.increment!(:order_number, 1)
      end
      TextBlock.create!(collection_id: @text_block.collection_id,
                        language: @text_block.language,
                        order_number: @text_block.order_number + 1,
                        contents: params[:last_contents].strip
                       )
      @text_block.update!(contents: params[:first_contents].strip)
      head(:ok)
    rescue
      render(json: {}, status: :unprocessable_entity)
    end
  end

  def tag_term
    @text_block = TextBlock.find(params[:id])
    @text_block.update!(text_blocks_params)
    head(:ok)
  rescue
    render(json: {}, status: :unprocessable_entity)
  end

  def export
    @collection = Collection.find(params[:collection_id])
    @text_blocks = @collection.text_blocks.order(:order_number)

    respond_to do |format|
      format.xlsx {
        @filename = "#{@collection.name_ka[..60]}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@filename}\""
      }
      format.docx {
        @language = params[:language]
        @filename = "#{@collection.send("name_#{@language}")}"[..60] + ".docx"
        response.headers["Content-Disposition"] = "attachment; filename=\"#{@filename}\""

        Caracal::Document.save @filename do |docx|
          docx.h1 @collection.send("name_#{@language}")
          @text_blocks.each do |text_block|
            docx.p text_block.contents if text_block.language == @language
          end
        end
        send_file(File.join(Rails.root, @filename))
      }
    end
  end

  private

  def set_search_params
    @search = Search::TextBlock.new(params.permit(:collection_id, :original_id, :original_contents, :translation_contents, :order_number))
  end

  def text_blocks_params
    params.require(:text_block).permit(:contents)
  end

end
