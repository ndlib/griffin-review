# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200422171148) do

  create_table "assignments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "role_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "error_logs", force: :cascade do |t|
    t.string   "netid",           limit: 255
    t.string   "path",            limit: 255
    t.text     "message",         limit: 65535
    t.text     "params",          limit: 65535
    t.text     "stack_trace",     limit: 65535
    t.datetime "created_at"
    t.string   "state",           limit: 255
    t.text     "user_agent",      limit: 65535
    t.string   "exception_class", limit: 255
  end

  create_table "fair_use_questions", force: :cascade do |t|
    t.text    "question",    limit: 65535
    t.boolean "active"
    t.string  "category",    limit: 255
    t.integer "ord",         limit: 4
    t.string  "subcategory", limit: 255
  end

  add_index "fair_use_questions", ["ord"], name: "index_fair_use_questions_on_ord", using: :btree

  create_table "fair_uses", force: :cascade do |t|
    t.text     "fair_uses",  limit: 65535
    t.text     "comments",   limit: 65535
    t.string   "state",      limit: 255
    t.integer  "user_id",    limit: 4
    t.integer  "request_id", limit: 4
    t.integer  "item_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fair_uses", ["item_id"], name: "index_fair_uses_on_item_id", using: :btree
  add_index "fair_uses", ["request_id"], name: "index_fair_uses_on_request_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "selection_title",               limit: 255
    t.text     "description",                   limit: 65535
    t.integer  "item_type_id",                  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "creator",                       limit: 255
    t.text     "title",                         limit: 65535
    t.text     "journal_title",                 limit: 65535
    t.string   "nd_meta_data_id",               limit: 255
    t.boolean  "overwrite_nd_meta_data"
    t.text     "length",                        limit: 65535
    t.string   "pdf_file_name",                 limit: 255
    t.string   "pdf_file_size",                 limit: 255
    t.string   "pdf_content_type",              limit: 255
    t.string   "pdf_updated_at",                limit: 255
    t.text     "url",                           limit: 65535
    t.string   "type",                          limit: 255
    t.string   "publisher",                     limit: 255
    t.boolean  "on_order"
    t.text     "details",                       limit: 65535
    t.datetime "metadata_synchronization_date"
    t.string   "display_length",                limit: 255
    t.text     "citation",                      limit: 65535
    t.boolean  "physical_reserve"
    t.string   "realtime_availability_id",      limit: 255
    t.boolean  "electronic_reserve"
    t.string   "contributor",                   limit: 255
  end

  add_index "items", ["type"], name: "index_items_on_type", using: :btree

  create_table "media_playlists", force: :cascade do |t|
    t.integer "item_id", limit: 4
    t.text    "data",    limit: 4294967295
  end

  create_table "messages", force: :cascade do |t|
    t.string   "creator",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content",    limit: 65535
    t.integer  "request_id", limit: 4
  end

  add_index "messages", ["request_id"], name: "index_messages_on_request_id", using: :btree

  create_table "requests", force: :cascade do |t|
    t.integer  "user_id",                    limit: 4
    t.date     "needed_by"
    t.integer  "semester_id",                limit: 4
    t.string   "title",                      limit: 255
    t.string   "course",                     limit: 255
    t.boolean  "repeat_request"
    t.boolean  "library_owned"
    t.string   "language",                   limit: 255
    t.string   "subtitles",                  limit: 255
    t.text     "note",                       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_state",             limit: 255
    t.datetime "workflow_state_change_date"
    t.integer  "workflow_state_change_user", limit: 4
    t.integer  "video_id",                   limit: 4
    t.integer  "number_of_copies",           limit: 4
    t.string   "requestor_owns_a_copy",      limit: 255
    t.string   "library",                    limit: 255
    t.string   "course_id",                  limit: 255
    t.string   "crosslist_id",               limit: 255
    t.string   "requestor_netid",            limit: 255
    t.integer  "item_id",                    limit: 4
    t.boolean  "reviewed"
    t.boolean  "currently_in_aleph"
    t.text     "item_title",                 limit: 65535
    t.string   "item_selection_title",       limit: 255
    t.string   "item_type",                  limit: 255
    t.boolean  "item_physical_reserve"
    t.boolean  "item_electronic_reserve"
    t.boolean  "item_on_order"
    t.text     "sortable_title",             limit: 65535
    t.boolean  "required_material"
  end

  add_index "requests", ["course_id"], name: "index_requests_on_course_id", using: :btree
  add_index "requests", ["crosslist_id"], name: "index_requests_on_crosslist_id", using: :btree
  add_index "requests", ["library"], name: "index_requests_on_library", using: :btree
  add_index "requests", ["requestor_netid"], name: "index_requests_on_requestor_netid", using: :btree
  add_index "requests", ["workflow_state"], name: "index_requests_on_workflow_state", using: :btree

  create_table "reserve_stats", force: :cascade do |t|
    t.integer  "request_id",  limit: 4
    t.integer  "item_id",     limit: 4
    t.integer  "semester_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.boolean  "from_lms"
  end

  add_index "reserve_stats", ["item_id"], name: "index_reserve_stats_on_item_id", using: :btree
  add_index "reserve_stats", ["request_id"], name: "index_reserve_stats_on_request_id", using: :btree

  create_table "sakai_context_cache", force: :cascade do |t|
    t.string   "context_id", limit: 255
    t.string   "course_id",  limit: 255
    t.string   "term",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sakai_context_cache", ["context_id"], name: "index_sakai_context_cache_on_context_id", using: :btree
  add_index "sakai_context_cache", ["course_id"], name: "index_sakai_context_cache_on_course_id", using: :btree
  add_index "sakai_context_cache", ["term"], name: "index_sakai_context_cache_on_term", using: :btree

  create_table "semesters", force: :cascade do |t|
    t.string   "code",            limit: 255
    t.string   "full_name",       limit: 255
    t.date     "date_begin"
    t.date     "date_end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "movie_directory", limit: 255
  end

  create_table "user_course_exceptions", force: :cascade do |t|
    t.string "netid",     limit: 255
    t.string "role",      limit: 255
    t.string "course_id", limit: 255
    t.string "term",      limit: 255
  end

  add_index "user_course_exceptions", ["course_id", "term", "role"], name: "uce_search_index", using: :btree
  add_index "user_course_exceptions", ["netid", "term"], name: "index_user_course_exceptions_on_netid_and_term", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",           limit: 255
    t.string   "last_name",            limit: 255
    t.string   "display_name",         limit: 255
    t.string   "email",                limit: 255,   default: "", null: false
    t.integer  "sign_in_count",        limit: 4,     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.string   "username",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.text     "admin_preferences",    limit: 65535
    t.string   "authentication_token", limit: 30
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 65535
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "video_titles", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "wowza_tokens", force: :cascade do |t|
    t.string   "username",   limit: 255
    t.string   "token",      limit: 255
    t.string   "ip",         limit: 255
    t.integer  "timestamp",  limit: 8,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wowza_tokens", ["token"], name: "index_wowza_tokens_on_token", using: :btree

  add_foreign_key "messages", "requests"
end
