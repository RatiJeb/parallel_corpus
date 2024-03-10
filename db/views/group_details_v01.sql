SELECT
  groups.id,
  groups.name_ka,
  groups.name_en,
  groups.status,
  supergroups.id AS supergroup_id,
  supergroups.name_ka AS supergroup_name_ka,
  supergroups.name_en AS supergroup_name_en,
  COUNT(DISTINCT collections.id) AS collections_count,
  COUNT(text_blocks.id) AS text_blocks_count

FROM groups
INNER JOIN supergroups ON groups.supergroup_id = supergroups.id
LEFT OUTER JOIN collections ON groups.id = collections.group_id
LEFT OUTER JOIN text_blocks ON collections.id = text_blocks.collection_id

GROUP BY groups.id, groups.name_ka, groups.name_en, groups.status, supergroups.id, supergroups.name_ka, supergroups.name_en
