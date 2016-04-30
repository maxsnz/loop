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

ActiveRecord::Schema.define(version: 20151022144836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: :cascade do |t|
    t.string   "uid",                    null: false
    t.string   "name"
    t.string   "email"
    t.integer  "score",      default: 0, null: false
    t.string   "picture"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["uid"], name: "index_players_on_uid", unique: true, using: :btree

  create_table "results", force: :cascade do |t|
    t.integer  "player_id",                                         null: false
    t.string   "state",                                             null: false
    t.decimal  "seconds",    precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "start",      precision: 12, scale: 2,               null: false
    t.integer  "score",                                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "uid",        null: false
    t.string   "token",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokens", ["uid", "token"], name: "index_tokens_on_uid_and_token", unique: true, using: :btree

end
