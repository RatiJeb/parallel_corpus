module Admin
  module TextBlocks
    class UpdateMultipleService
      def initialize(params)
        @params = params
      end

      def call
        ActiveRecord::Base.transaction do
          @collection = Collection.find(@params[:collection_id])
          destroy_multiple
          update_multiple
          create_multiple
        end
      end

      private

      def destroy_multiple
        @collection.text_blocks.where.not(id: @params[:text_blocks].pluck(:id)).destroy_all
      end

      def update_multiple
        TextBlock.upsert_all(
          @params[:text_blocks]
            .reject { |tb| tb[:id].to_s.include?('new') }
            .map do |tb|
              param = tb.as_json
              param['collection_id'] = @params[:collection_id]
              param
            end,
        )
      end

      def create_multiple
        TextBlock.upsert_all(
          @params[:text_blocks]
            .select { |tb| tb[:id].to_s.include?('new') }
            .map do |tb|
              param = tb.as_json.except('id')
              param['collection_id'] = @params[:collection_id]
              param
            end,
        )
      end
    end
  end
end
