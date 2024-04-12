# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_12_001112) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "name_ka"
    t.string "name_en"
    t.integer "status", default: 0, null: false
    t.text "comment"
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_en"], name: "index_authors_on_name_en", unique: true
    t.index ["name_ka"], name: "index_authors_on_name_ka", unique: true
    t.index ["old_id"], name: "index_authors_on_old_id", unique: true
  end

  create_table "collection_authors", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_collection_authors_on_author_id"
    t.index ["collection_id", "author_id"], name: "index_collection_authors_on_collection_id_and_author_id", unique: true
    t.index ["collection_id"], name: "index_collection_authors_on_collection_id"
  end

  create_table "collection_fields", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "field_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "field_id"], name: "index_collection_fields_on_collection_id_and_field_id", unique: true
    t.index ["collection_id"], name: "index_collection_fields_on_collection_id"
    t.index ["field_id"], name: "index_collection_fields_on_field_id"
  end

  create_table "collection_genres", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "genre_id"], name: "index_collection_genres_on_collection_id_and_genre_id", unique: true
    t.index ["collection_id"], name: "index_collection_genres_on_collection_id"
    t.index ["genre_id"], name: "index_collection_genres_on_genre_id"
  end

  create_table "collection_publishings", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "publishing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "publishing_id"], name: "idx_on_collection_id_publishing_id_0dac681148", unique: true
    t.index ["collection_id"], name: "index_collection_publishings_on_collection_id"
    t.index ["publishing_id"], name: "index_collection_publishings_on_publishing_id"
  end

  create_table "collection_translators", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "translator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "translator_id"], name: "idx_on_collection_id_translator_id_638129e1b1", unique: true
    t.index ["collection_id"], name: "index_collection_translators_on_collection_id"
    t.index ["translator_id"], name: "index_collection_translators_on_translator_id"
  end

  create_table "collection_types", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "type_id"], name: "index_collection_types_on_collection_id_and_type_id", unique: true
    t.index ["collection_id"], name: "index_collection_types_on_collection_id"
    t.index ["type_id"], name: "index_collection_types_on_type_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name_ka", null: false
    t.string "name_en", null: false
    t.text "comment"
    t.text "additional_info"
    t.integer "year"
    t.integer "translation_year"
    t.integer "original_language", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id", null: false
    t.boolean "should_unsync", default: false, null: false
    t.index ["group_id", "name_en"], name: "index_collections_on_group_id_and_name_en", unique: true
    t.index ["group_id", "name_ka"], name: "index_collections_on_group_id_and_name_ka", unique: true
    t.index ["group_id"], name: "index_collections_on_group_id"
    t.index ["old_id"], name: "index_collections_on_old_id", unique: true
  end

  create_table "fields", force: :cascade do |t|
    t.string "name_ka"
    t.string "name_en"
    t.integer "status", default: 0, null: false
    t.text "comment"
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_ka", "name_en"], name: "index_fields_on_name_ka_and_name_en", unique: true
    t.index ["old_id"], name: "index_fields_on_old_id", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.string "name_ka"
    t.string "name_en"
    t.integer "status", default: 0, null: false
    t.text "comment"
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_ka", "name_en"], name: "index_genres_on_name_ka_and_name_en", unique: true
    t.index ["old_id"], name: "index_genres_on_old_id", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string "name_ka", null: false
    t.string "name_en", null: false
    t.text "comment"
    t.text "additional_info"
    t.integer "status", default: 0, null: false
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "supergroup_id", null: false
    t.boolean "should_sync", default: false, null: false
    t.index ["old_id"], name: "index_groups_on_old_id", unique: true
    t.index ["supergroup_id", "name_en"], name: "index_groups_on_supergroup_id_and_name_en", unique: true
    t.index ["supergroup_id", "name_ka"], name: "index_groups_on_supergroup_id_and_name_ka", unique: true
    t.index ["supergroup_id"], name: "index_groups_on_supergroup_id"
  end

  create_table "publishings", force: :cascade do |t|
    t.string "name_ka"
    t.string "name_en"
    t.integer "status", default: 0, null: false
    t.text "comment"
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_ka", "name_en"], name: "index_publishings_on_name_ka_and_name_en", unique: true
    t.index ["old_id"], name: "index_publishings_on_old_id", unique: true
  end

  create_table "supergroups", force: :cascade do |t|
    t.string "name_ka", null: false
    t.string "name_en", null: false
    t.text "comment"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_en"], name: "index_supergroups_on_name_en", unique: true
    t.index ["name_ka"], name: "index_supergroups_on_name_ka", unique: true
  end

  create_table "terms", force: :cascade do |t|
    t.integer "old_id"
    t.integer "old_text_id"
    t.text "term"
    t.bigint "text_block_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["old_id"], name: "index_terms_on_old_id", unique: true
    t.index ["text_block_id"], name: "index_terms_on_text_block_id"
  end

  create_table "text_blocks", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.text "contents"
    t.integer "order_number", null: false
    t.integer "language", default: 0, null: false
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "order_number", "language"], name: "idx_on_collection_id_order_number_language_42425d13fb", unique: true
    t.index ["collection_id"], name: "index_text_blocks_on_collection_id"
    t.index ["old_id", "language"], name: "index_text_blocks_on_old_id_and_language", unique: true
  end

  create_table "translators", force: :cascade do |t|
    t.string "name_ka"
    t.string "name_en"
    t.integer "status", default: 0, null: false
    t.text "comment"
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_en"], name: "index_translators_on_name_en", unique: true
    t.index ["name_ka"], name: "index_translators_on_name_ka", unique: true
    t.index ["old_id"], name: "index_translators_on_old_id", unique: true
  end

  create_table "types", force: :cascade do |t|
    t.string "name_ka"
    t.string "name_en"
    t.integer "status", default: 0, null: false
    t.text "comment"
    t.integer "old_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_ka", "name_en"], name: "index_types_on_name_ka_and_name_en", unique: true
    t.index ["old_id"], name: "index_types_on_old_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collection_authors", "authors"
  add_foreign_key "collection_authors", "collections"
  add_foreign_key "collection_fields", "collections"
  add_foreign_key "collection_fields", "fields"
  add_foreign_key "collection_genres", "collections"
  add_foreign_key "collection_genres", "genres"
  add_foreign_key "collection_publishings", "collections"
  add_foreign_key "collection_publishings", "publishings"
  add_foreign_key "collection_translators", "collections"
  add_foreign_key "collection_translators", "translators"
  add_foreign_key "collection_types", "collections"
  add_foreign_key "collection_types", "types"
  add_foreign_key "collections", "groups"
  add_foreign_key "groups", "supergroups"
  add_foreign_key "terms", "text_blocks"
  add_foreign_key "text_blocks", "collections"

  create_view "supergroup_details", sql_definition: <<-SQL
      SELECT supergroups.id,
      supergroups.name_ka,
      supergroups.name_en,
      supergroups.status,
      count(DISTINCT groups.id) AS groups_count,
      count(DISTINCT collections.id) AS collections_count,
      count(text_blocks.id) AS text_blocks_count
     FROM (((supergroups
       LEFT JOIN groups ON ((supergroups.id = groups.supergroup_id)))
       LEFT JOIN collections ON ((groups.id = collections.group_id)))
       LEFT JOIN text_blocks ON (((collections.id = text_blocks.collection_id) AND (text_blocks.language = 0))))
    GROUP BY supergroups.id, supergroups.name_ka, supergroups.name_en, supergroups.status;
  SQL
  create_view "group_details", sql_definition: <<-SQL
      SELECT groups.id,
      groups.name_ka,
      groups.name_en,
      groups.status,
      supergroups.id AS supergroup_id,
      supergroups.name_ka AS supergroup_name_ka,
      supergroups.name_en AS supergroup_name_en,
      count(DISTINCT collections.id) AS collections_count,
      count(text_blocks.id) AS text_blocks_count
     FROM (((groups
       JOIN supergroups ON ((groups.supergroup_id = supergroups.id)))
       LEFT JOIN collections ON ((groups.id = collections.group_id)))
       LEFT JOIN text_blocks ON (((collections.id = text_blocks.collection_id) AND (text_blocks.language = 0))))
    GROUP BY groups.id, groups.name_ka, groups.name_en, groups.status, supergroups.id, supergroups.name_ka, supergroups.name_en;
  SQL
  create_view "collection_details", sql_definition: <<-SQL
      SELECT collections.id,
      collections.name_ka,
      collections.name_en,
      collections.status,
      groups.id AS group_id,
      groups.name_ka AS group_name_ka,
      groups.name_en AS group_name_en,
      supergroups.id AS supergroup_id,
      supergroups.name_ka AS supergroup_name_ka,
      supergroups.name_en AS supergroup_name_en,
      count(text_blocks.id) AS text_blocks_count
     FROM (((collections
       JOIN groups ON ((collections.group_id = groups.id)))
       JOIN supergroups ON ((groups.supergroup_id = supergroups.id)))
       LEFT JOIN text_blocks ON (((collections.id = text_blocks.collection_id) AND (text_blocks.language = 0))))
    GROUP BY collections.id, collections.name_ka, collections.name_en, collections.status, groups.id, groups.name_ka, groups.name_en, supergroups.id, supergroups.name_ka, supergroups.name_en;
  SQL
  create_view "text_block_pairs", sql_definition: <<-SQL
      SELECT concat((tb_left.id)::text, '-', (tb_right.id)::text) AS id,
      tb_left.id AS original_id,
      tb_left.order_number,
      tb_left.collection_id,
      tb_left.contents AS original_contents,
      tb_left.language AS original_language,
      tb_right.id AS translation_id,
      tb_right.contents AS translation_contents,
      tb_right.language AS translation_language
     FROM (text_blocks tb_left
       FULL JOIN text_blocks tb_right ON (((tb_left.collection_id = tb_right.collection_id) AND (tb_left.order_number = tb_right.order_number) AND (tb_left.language <> tb_right.language))));
  SQL
end
