SELECT
  collections.id,
  collections.name_ka,
  collections.name_en,
  collections.status,
  groups.id AS group_id,
  groups.name_ka AS group_name_ka,
  groups.name_en AS group_name_en,
  supergroups.id AS supergroup_id,
  supergroups.name_ka AS supergroup_name_ka,
  supergroups.name_en AS supergroup_name_en,
  COUNT(text_blocks.id) AS text_blocks_count

FROM collections
INNER JOIN groups ON collections.group_id = groups.id
INNER JOIN supergroups ON groups.supergroup_id = supergroups.id
LEFT OUTER JOIN text_blocks ON collections.id = text_blocks.collection_id

GROUP BY collections.id, collections.name_ka, collections.name_en, collections.status, groups.id, groups.name_ka, groups.name_en, supergroups.id, supergroups.name_ka, supergroups.name_en
