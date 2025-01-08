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
        upsert_params = @params[:text_blocks].map do |tb|
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
                 language,
                 collection_id,
                 order_number,
                 old_id,
                 LOWER(REGEXP_REPLACE(word, '^[^ა-ჰa-zA-Z0-9]+|[^ა-ჰa-zA-Z0-9]+$', '', 'g')) AS value,
                 position
          FROM text_blocks
                   LEFT JOIN STRING_TO_TABLE(contents, ' ') WITH ORDINALITY AS WORD_WITH_POSITION(word, position) ON TRUE
          WHERE id IN (#{TextBlock.where(collection_id: @collection.id).ids.to_s[1...-1]})),
                   conflicted_records AS (
                       SELECT id, value, language
                       FROM text_block_components
                       WHERE value IN (
                           SELECT value
                           FROM cte
                           WHERE value IS NOT NULL AND value != ''
                       )
                   ),
                         inserted_records AS (
                             INSERT INTO text_block_components (value, language, created_at, updated_at)
                                 SELECT cte.value, cte.language, NOW(), NOW()
                                 FROM cte
                                 WHERE value IS NOT NULL AND value != ''
                                 ON CONFLICT (value) DO NOTHING
                                 RETURNING id, value, language
                         )
               INSERT INTO text_block_component_pivots(text_block_id, text_block_component_id, position)
                SELECT cte.id,
                       text_block_comp.id,
                       cte.position
                FROM cte
                  JOIN (SELECT id, value, language
                    FROM inserted_records
                    UNION ALL
                    SELECT id, value, language
                    FROM conflicted_records) text_block_comp ON text_block_comp.value = cte.value AND text_block_comp.language = cte.language;
        SQL
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
