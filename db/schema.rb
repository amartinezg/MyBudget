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

ActiveRecord::Schema.define(version: 20151229045414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "balance_cents",    default: 0,     null: false
    t.string   "balance_currency", default: "COP", null: false
  end

  create_table "movements", force: :cascade do |t|
    t.string   "category"
    t.string   "sub_category"
    t.string   "notes"
    t.integer  "amount_cents"
    t.string   "type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.date     "period"
    t.string   "account_id",   null: false
    t.date     "date"
  end

end
