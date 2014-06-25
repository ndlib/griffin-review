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

ActiveRecord::Schema.define(version: 20140624195343) do

  create_table "assignments", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "error_logs", force: true do |t|
    t.string   "netid"
    t.string   "path"
    t.text     "message"
    t.text     "params"
    t.text     "stack_trace"
    t.datetime "created_at"
    t.string   "state"
    t.text     "user_agent"
    t.string   "exception_class"
  end

  create_table "fair_use_questions", force: true do |t|
    t.text    "question"
    t.boolean "active"
    t.string  "category"
    t.integer "ord"
    t.string  "subcategory"
  end

  add_index "fair_use_questions", ["ord"], name: "index_fair_use_questions_on_ord", using: :btree

  create_table "fair_uses", force: true do |t|
    t.text     "fair_uses"
    t.text     "comments"
    t.string   "state"
    t.integer  "user_id"
    t.integer  "request_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fair_uses", ["item_id"], name: "index_fair_uses_on_item_id", using: :btree
  add_index "fair_uses", ["request_id"], name: "index_fair_uses_on_request_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "selection_title"
    t.text     "description"
    t.integer  "item_type_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "creator"
    t.string   "title"
    t.string   "journal_title"
    t.string   "nd_meta_data_id"
    t.boolean  "overwrite_nd_meta_data"
    t.string   "length"
    t.string   "pdf_file_name"
    t.string   "pdf_file_size"
    t.string   "pdf_content_type"
    t.string   "pdf_updated_at"
    t.text     "url"
    t.string   "type"
    t.string   "publisher"
    t.boolean  "on_order"
    t.string   "details"
    t.datetime "metadata_synchronization_date"
    t.string   "display_length"
    t.text     "citation"
    t.boolean  "physical_reserve"
    t.string   "realtime_availability_id"
    t.boolean  "electronic_reserve"
  end

  add_index "items", ["type"], name: "index_items_on_type", using: :btree

  create_table "requests", force: true do |t|
    t.integer  "user_id"
    t.date     "needed_by"
    t.integer  "semester_id"
    t.string   "title"
    t.string   "course"
    t.boolean  "repeat_request"
    t.boolean  "library_owned"
    t.string   "language"
    t.string   "subtitles"
    t.text     "note"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "workflow_state"
    t.datetime "workflow_state_change_date"
    t.integer  "workflow_state_change_user"
    t.integer  "video_id"
    t.integer  "number_of_copies"
    t.string   "requestor_owns_a_copy"
    t.string   "library"
    t.string   "course_id"
    t.string   "crosslist_id"
    t.string   "requestor_netid"
    t.integer  "item_id"
    t.boolean  "reviewed"
    t.boolean  "currently_in_aleph"
  end

  add_index "requests", ["course_id"], name: "index_requests_on_course_id", using: :btree
  add_index "requests", ["crosslist_id"], name: "index_requests_on_crosslist_id", using: :btree
  add_index "requests", ["library"], name: "index_requests_on_library", using: :btree
  add_index "requests", ["requestor_netid"], name: "index_requests_on_requestor_netid", using: :btree
  add_index "requests", ["workflow_state"], name: "index_requests_on_workflow_state", using: :btree

  create_table "reserve_stats", force: true do |t|
    t.integer  "request_id"
    t.integer  "item_id"
    t.integer  "semester_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.boolean  "from_lms"
  end

  add_index "reserve_stats", ["item_id"], name: "index_reserve_stats_on_item_id", using: :btree
  add_index "reserve_stats", ["request_id"], name: "index_reserve_stats_on_request_id", using: :btree

  create_table "sakai_context_cache", force: true do |t|
    t.string   "context_id"
    t.string   "course_id"
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sakai_context_cache", ["context_id"], name: "index_sakai_context_cache_on_context_id", using: :btree
  add_index "sakai_context_cache", ["course_id"], name: "index_sakai_context_cache_on_course_id", using: :btree
  add_index "sakai_context_cache", ["term"], name: "index_sakai_context_cache_on_term", using: :btree

  create_table "semesters", force: true do |t|
    t.string   "code"
    t.string   "full_name"
    t.date     "date_begin"
    t.date     "date_end"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "movie_directory"
  end

  create_table "user_course_exceptions", force: true do |t|
    t.string "netid"
    t.string "role"
    t.string "course_id"
    t.string "term"
  end

  add_index "user_course_exceptions", ["course_id", "term", "role"], name: "uce_search_index", using: :btree
  add_index "user_course_exceptions", ["netid", "term"], name: "index_user_course_exceptions_on_netid_and_term", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "email",              default: "", null: false
    t.integer  "sign_in_count",      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "admin"
    t.string   "admin_preferences"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
