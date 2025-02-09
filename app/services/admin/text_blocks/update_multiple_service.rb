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
          upsert_multiple
          upsert_multiple_components
        end
      end

      private

      def destroy_multiple
        text_blocks = @collection.text_blocks
        TextBlockComponentPivot.where(text_block_id: text_blocks.ids).delete_all
        text_blocks.delete_all
      end

      def upsert_multiple
        upsert_params = @params[:text_blocks].select { |tb| tb.keys.size == 4 }.map do |tb|
          param = tb.as_json(except: 'id')
          param['language'] = TextBlock.languages[param['language']]
          param['collection_id'] = @collection.id
          param['order_number'] = param['order_number'].to_i - 1
          param
        end
        TextBlock.upsert_all(upsert_params)
      end

      def upsert_multiple_components
        sql = <<~SQL
          WITH cte AS (SELECT id,
                              LOWER(REGEXP_REPLACE(word, '^[^ა-ჰa-zA-Z0-9]+|[^ა-ჰa-zA-Z0-9]+$', '', 'g')) AS value,
                              position
                       FROM text_blocks
                                LEFT JOIN string_to_table(contents, ' ') WITH ORDINALITY AS word_with_position(word, position)
                                          ON TRUE
                       WHERE collection_id = #{@collection.id}),
               insert_new_components AS (
                   INSERT INTO text_block_components (value)
                       SELECT DISTINCT cte.value
                       FROM cte
                                LEFT JOIN text_block_components comp ON cte.value = comp.value
                       WHERE cte.value IS NOT NULL
                         AND cte.value != ''
                         AND comp.value IS NULL)
          INSERT
          INTO text_block_component_pivots (text_block_id, text_block_component_id, position)
          SELECT cte.id, text_block_components.id, cte.position
          FROM cte
                   INNER JOIN text_block_components ON cte.value = text_block_components.value;
        SQL
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
