-- EXPLAIN ANALYZE
SELECT
  CONCAT(tb_left.id::text, '-', tb_right.id::text) AS id,
  tb_left.id AS original_id,
  tb_left.order_number AS order_number,
  tb_left.collection_id AS collection_id,
  tb_left.contents AS original_contents,
  col_left.original_language AS original_language,

  tb_right.id AS translation_id,
  tb_right.contents AS translation_contents

  FROM text_blocks tb_left
  INNER JOIN collections col_left on tb_left.collection_id = col_left.id
  FULL OUTER JOIN text_blocks tb_right
  ON tb_left.collection_id = tb_right.collection_id AND
     tb_left.order_number = tb_right.order_number AND
     tb_left.language <> tb_right.language
