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

ActiveRecord::Schema.define(version: 20141107032100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "convos", primary_key: "convo_id", force: true do |t|
    t.integer  "thread_convo_id"
    t.integer  "sender_user_id",                                null: false
    t.integer  "recipient_user_id",                             null: false
    t.string   "subject_line",      limit: 140,                 null: false
    t.text     "body",                                          null: false
    t.string   "state",                         default: "new"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "convos", ["thread_convo_id"], name: "index_convos_on_thread_convo_id", using: :btree

  create_table "users", primary_key: "user_id", force: true do |t|
    t.string   "user_name",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["user_name"], name: "index_users_on_user_name", unique: true, using: :btree

end
