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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130605133002) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "basic_metadata", :force => true do |t|
    t.integer  "metadata_attribute_id"
    t.integer  "item_id"
    t.string   "value"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "item_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "item_type_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "creator"
    t.string   "title"
    t.string   "journal_title"
    t.string   "nd_meta_data_id"
    t.boolean  "overwrite_nd_meta_data"
    t.string   "length"
    t.string   "file"
    t.string   "url"
    t.string   "type"
    t.string   "publisher"
  end

  add_index "items", ["type"], :name => "index_items_on_type"

  create_table "metadata_attributes", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "metadata_type"
  end

  create_table "requests", :force => true do |t|
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
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "workflow_state"
    t.datetime "workflow_state_change_date"
    t.integer  "workflow_state_change_user"
    t.integer  "video_id"
    t.integer  "number_of_copies"
    t.string   "requestor_owns_a_copy"
    t.string   "library"
    t.string   "course_id"
    t.string   "requestor_netid"
    t.integer  "item_id"
  end

  add_index "requests", ["course_id"], :name => "index_requests_on_course_id"
  add_index "requests", ["library"], :name => "index_requests_on_library"
  add_index "requests", ["requestor_netid"], :name => "index_requests_on_requestor_netid"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "semesters", :force => true do |t|
    t.string   "code"
    t.string   "full_name"
    t.date     "date_begin"
    t.date     "date_end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "technical_metadata", :force => true do |t|
    t.integer  "item_id"
    t.integer  "metadata_attribute_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "value"
  end

  create_table "test_requests", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "type"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "test_requests", ["type"], :name => "index_test_requests_on_type"

  create_table "user_course_exceptions", :force => true do |t|
    t.string "netid"
    t.string "role"
    t.string "section_id"
    t.string "semester_code"
  end

  add_index "user_course_exceptions", ["netid", "semester_code"], :name => "index_user_course_exceptions_on_netid_and_semester_code"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "email",              :default => "", :null => false
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
