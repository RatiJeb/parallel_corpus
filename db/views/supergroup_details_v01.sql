SELECT
  supergroups.id,
  supergroups.name_ka,
  supergroups.name_en,
  supergroups.status,
  COUNT(DISTINCT groups.id) AS groups_count,
  COUNT(DISTINCT collections.id) AS collections_count,
  COUNT(text_blocks.id) AS text_blocks_count

FROM supergroups
LEFT OUTER JOIN groups ON supergroups.id = groups.supergroup_id
LEFT OUTER JOIN collections ON groups.id = collections.group_id
LEFT OUTER JOIN text_blocks ON collections.id = text_blocks.collection_id

GROUP BY supergroups.id, supergroups.name_ka, supergroups.name_en, supergroups.status
