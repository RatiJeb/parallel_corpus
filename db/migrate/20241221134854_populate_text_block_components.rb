class PopulateTextBlockComponents < ActiveRecord::Migration[7.1]
  def up
    sql = <<~SQL
      WITH cte AS (SELECT id,
       language,
       collection_id,
       order_number,
       old_id,
       LOWER(REGEXP_REPLACE(word, '^[^ა-ჰa-zA-Z0-9]+|[^ა-ჰa-zA-Z0-9]+$', '', 'g')) as value,
       position
                   FROM text_blocks
         left join string_to_table(contents, ' ') with ordinality AS word_with_position(word, position) on true),
           inserted_text_block_components AS (
               INSERT INTO text_block_components (value, language, created_at, updated_at)
                   SELECT value,
                          language,
                          NOW(),
                          NOW()
                   FROM cte
                   WHERE value is not null
                     and value != ''
                   ON CONFLICT (value) DO NOTHING
                   RETURNING id, value, language)
      INSERT
      INTO text_block_component_pivots(text_block_id, text_block_component_id, position)
      SELECT cte.id,
             text_block_comp.id,
             cte.position
      FROM cte
               JOIN inserted_text_block_components text_block_comp ON text_block_comp.value = cte.value;
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    TextBlockComponentPivot.delete_all
    TextBlockComponent.delete_all
  end
end
