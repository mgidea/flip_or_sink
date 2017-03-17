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

ActiveRecord::Schema.define(version: 20170311165755) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "geo_key"
    t.float    "geo_center_latitude"
    t.float    "geo_center_longitude"
    t.integer  "state_id"
    t.integer  "county_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["county_id"], name: "index_cities_on_county_id", using: :btree
    t.index ["state_id"], name: "index_cities_on_state_id", using: :btree
  end

  create_table "counties", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "geo_key"
    t.float    "geo_center_latitude"
    t.float    "geo_center_longitude"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "state_id"
    t.index ["state_id"], name: "index_counties_on_state_id", using: :btree
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "code"
    t.string   "geo_key"
    t.float    "geo_center_latitude"
    t.float    "geo_center_longitude"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string   "postal_code"
    t.string   "code"
    t.string   "geo_key"
    t.float    "geo_center_latitude"
    t.float    "geo_center_longitude"
    t.integer  "city_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["city_id"], name: "index_zip_codes_on_city_id", using: :btree
  end

end
