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

ActiveRecord::Schema.define(version: 20160229162131) do

  create_table "categories", force: true do |t|
    t.string   "name",       limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapters", force: true do |t|
    t.integer  "post_id",    null: false
    t.integer  "series_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapters", ["post_id"], name: "index_chapters_on_post_id", unique: true
  add_index "chapters", ["series_id"], name: "index_chapters_on_series_id"

  create_table "posts", force: true do |t|
    t.string   "author",     limit: 50
    t.datetime "date"
    t.string   "title",      limit: 250
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link",       limit: 250
  end

  create_table "series", force: true do |t|
    t.string   "name",       limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.integer  "post_id",     null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["category_id"], name: "index_tags_on_category_id"
  add_index "tags", ["post_id", "category_id"], name: "index_tags_on_post_id_and_category_id", unique: true
  add_index "tags", ["post_id"], name: "index_tags_on_post_id"

end
