require 'tempfile'

class Admin::TextBlocksController < Admin::BaseController
  before_action :set_search_params, only: [:index, :edit_multiple]

  def index
    @collection = Collection.find(params[:collection_id]) unless params[:collection_id].blank?

    @text_blocks = TextBlock.all

    @text_blocks = @text_blocks.where(collection_id: params[:collection_id]) unless params[:collection_id].blank?
    @text_blocks = @text_blocks.where(id: params[:original_id]) unless params[:original_id].blank?

    if params[:original_contents].present?
      ka_text_blocks = @text_blocks.where(language: :ka).where(TextBlock.arel_table[:contents].matches("%#{params[:original_contents]}%"))
      en_text_blocks = @text_blocks.where(language: :en).where(order_number: ka_text_blocks.pluck(:order_number))
      if params[:translation_contents].present?
        en_text_blocks = en_text_blocks.where(TextBlock.arel_table[:contents].matches("%#{params[:translation_contents]}%"))
        ka_text_blocks = @text_blocks.where(language: :ka).where(order_number: en_text_blocks.pluck(:order_number))
      end
      @text_blocks = ka_text_blocks.or(en_text_blocks)
    elsif params[:translation_contents].present?
      en_text_blocks = @text_blocks.where(language: :en).where(TextBlock.arel_table[:contents].matches("%#{params[:translation_contents]}%"))
      ka_text_blocks = @text_blocks.where(language: :ka).where(order_number: en_text_blocks.pluck(:order_number))
      @text_blocks = ka_text_blocks.or(en_text_blocks)
    end

    @text_blocks = @text_blocks.order(:order_number).page(params[:page]).per(40)
  end

  def new
    render(
      partial: 'edit_card',
      locals: {
        block: TextBlock.new(order_number: params[:order_number],
                             collection_id: params[:collection_id],
                             contents: params[:contents]),
        language: params[:language],
        order_number: params[:order_number].to_i,
        new_id: "new-#{SecureRandom.uuid}",
        selected_block_id: -1,
      },
      )
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
    rescue => e
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
    rescue => e
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

  def update_multiple
    Admin::TextBlocks::UpdateMultipleService.new(update_multiple_params).call
    render(json: { updated: true }, status: :ok)
  end

  def destroy_multiple
    if params[:collection_id].present?
      @collection = Collection.find(params[:collection_id])
      @text_blocks = @collection.text_blocks
    else
      @text_blocks = TextBlock.where(id: params[:ids])
    end
    ActiveRecord::Base.transaction do
      @text_blocks.each(&:destroy!)
      head(:ok)
    rescue => e
      render(json: {}, status: :unprocessable_entity)
    end
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

        Caracal::Document.save(@filename) do |docx|
          docx.h1(@collection.send("name_#{@language}"))
          @text_blocks.each do |text_block|
            docx.p(text_block.contents) if text_block.language == @language
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

  def update_multiple_params
    params.permit(:collection_id, text_blocks: [:language, :id, :order_number, :contents])
  end
end
