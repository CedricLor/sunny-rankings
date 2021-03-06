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

ActiveRecord::Schema.define(version: 20150819215151) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "city"
    t.string   "street"
    t.string   "number"
    t.string   "zip_code"
    t.string   "country"
    t.string   "addr_complement"
    t.string   "fuzzy_address"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "addresses_profiles", id: false, force: :cascade do |t|
    t.integer "profile_id", null: false
    t.integer "address_id", null: false
  end

  add_index "addresses_profiles", ["address_id", "profile_id"], name: "index_addresses_profiles_on_address_id_and_profile_id", using: :btree
  add_index "addresses_profiles", ["profile_id", "address_id"], name: "index_addresses_profiles_on_profile_id_and_address_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "user_rating"
    t.integer  "review_id"
    t.integer  "test_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["review_id"], name: "index_answers_on_review_id", using: :btree
  add_index "answers", ["test_id"], name: "index_answers_on_test_id", using: :btree

  create_table "awards", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "email_addresses", force: :cascade do |t|
    t.string   "address"
    t.integer  "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "firm_addresses", force: :cascade do |t|
    t.integer  "firm_id"
    t.integer  "address_id"
    t.string   "type_of_address"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "firm_addresses", ["address_id"], name: "index_firm_addresses_on_address_id", using: :btree
  add_index "firm_addresses", ["firm_id"], name: "index_firm_addresses_on_firm_id", using: :btree

  create_table "firm_creation_requests", force: :cascade do |t|
    t.string   "country_of_requester"
    t.string   "city_of_requester"
    t.string   "country_of_firm"
    t.string   "city_of_firm"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "user_id"
    t.integer  "requested_firm_id"
  end

  add_index "firm_creation_requests", ["requested_firm_id"], name: "index_firm_creation_requests_on_requested_firm_id", using: :btree
  add_index "firm_creation_requests", ["user_id"], name: "index_firm_creation_requests_on_user_id", using: :btree

  create_table "firms", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "country"
    t.integer  "headcount"
    t.text     "business_description"
    t.string   "industry"
    t.string   "icon_name"
    t.string   "reg_number"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "naf_code"
    t.integer  "number_of_researches", null: false
    t.integer  "number_of_views",      null: false
  end

  add_index "firms", ["naf_code"], name: "index_firms_on_naf_code", using: :btree

  create_table "granted_awards", force: :cascade do |t|
    t.integer  "award_id"
    t.integer  "firm_id"
    t.text     "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "granted_awards", ["award_id"], name: "index_granted_awards_on_award_id", using: :btree
  add_index "granted_awards", ["firm_id"], name: "index_granted_awards_on_firm_id", using: :btree

  create_table "low_level_industries", force: :cascade do |t|
    t.string   "naf_code",              null: false
    t.string   "naf_title_fr"
    t.string   "naf_title_en"
    t.integer  "top_level_industry_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "low_level_industries", ["naf_code"], name: "index_low_level_industries_on_naf_code", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mother_maiden_name"
    t.string   "address"
    t.string   "phone_number"
    t.string   "country"
    t.string   "employer_name"
    t.string   "current_position"
    t.integer  "age"
    t.string   "gender"
    t.boolean  "validated"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "default_email_id"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "requested_firms", force: :cascade do |t|
    t.string   "name"
    t.integer  "number_of_requests"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "review_portfolios", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "review_portfolios", ["user_id"], name: "index_review_portfolios_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "review_portfolio_id"
    t.integer  "firm_id"
    t.string   "user_firm_relationship"
    t.boolean  "confirmed_t_and_c",                  default: false
    t.boolean  "validated",                          default: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.text     "comment"
    t.string   "title",                  limit: 255
    t.boolean  "agreed_for_publication",             default: false, null: false
    t.boolean  "publishable",                        default: false, null: false
    t.boolean  "featured"
    t.string   "created_at_ip"
    t.string   "updated_at_ip"
    t.string   "token",                              default: ""
    t.integer  "down_votes",                         default: 0
    t.integer  "up_votes",                           default: 0
  end

  add_index "reviews", ["firm_id"], name: "index_reviews_on_firm_id", using: :btree
  add_index "reviews", ["review_portfolio_id"], name: "index_reviews_on_review_portfolio_id", using: :btree

  create_table "tests", force: :cascade do |t|
    t.string   "test_question"
    t.string   "test_long_question"
    t.string   "select_options"
    t.string   "positive_negative_switch"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "top_level_industries", force: :cascade do |t|
    t.string   "naf_code",     null: false
    t.string   "naf_title_fr"
    t.string   "naf_title_en"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "top_level_industries", ["naf_code"], name: "index_top_level_industries_on_naf_code", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "validated",              default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false, null: false
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "answers", "reviews"
  add_foreign_key "answers", "tests"
  add_foreign_key "firm_addresses", "addresses"
  add_foreign_key "firm_addresses", "firms"
  add_foreign_key "firm_creation_requests", "requested_firms"
  add_foreign_key "firm_creation_requests", "users"
  add_foreign_key "firms", "low_level_industries", column: "naf_code", primary_key: "naf_code", name: "naf_code"
  add_foreign_key "granted_awards", "awards"
  add_foreign_key "granted_awards", "firms"
  add_foreign_key "review_portfolios", "users"
  add_foreign_key "reviews", "firms"
  add_foreign_key "reviews", "review_portfolios"
end
