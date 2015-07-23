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

ActiveRecord::Schema.define(version: 20150723134713) do

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

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

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

  add_index "addresses_profiles", ["address_id", "profile_id"], name: "index_addresses_profiles_on_address_id_and_profile_id"
  add_index "addresses_profiles", ["profile_id", "address_id"], name: "index_addresses_profiles_on_profile_id_and_address_id"

  create_table "answers", force: :cascade do |t|
    t.integer  "user_rating"
    t.integer  "review_id"
    t.integer  "test_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["review_id"], name: "index_answers_on_review_id"
  add_index "answers", ["test_id"], name: "index_answers_on_test_id"

  create_table "awards", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "firm_addresses", force: :cascade do |t|
    t.integer  "firm_id"
    t.integer  "address_id"
    t.string   "type_of_address"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "firm_addresses", ["address_id"], name: "index_firm_addresses_on_address_id"
  add_index "firm_addresses", ["firm_id"], name: "index_firm_addresses_on_firm_id"

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
  end

  add_index "firms", ["naf_code"], name: "index_firms_on_naf_code"

  create_table "granted_awards", force: :cascade do |t|
    t.integer  "award_id"
    t.integer  "firm_id"
    t.text     "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "granted_awards", ["award_id"], name: "index_granted_awards_on_award_id"
  add_index "granted_awards", ["firm_id"], name: "index_granted_awards_on_firm_id"

  create_table "low_level_industries", force: :cascade do |t|
    t.string   "naf_code",              null: false
    t.string   "naf_title_fr"
    t.string   "naf_title_en"
    t.integer  "top_level_industry_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "low_level_industries", ["naf_code"], name: "index_low_level_industries_on_naf_code"

  create_table "profiles", force: :cascade do |t|
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
    t.string   "real_email"
    t.boolean  "validated"
    t.boolean  "first_time_login_upon_firm_review"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id"

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "firm_id"
    t.string   "user_firm_relationship"
    t.boolean  "confirmed_t_and_c",      default: false
    t.boolean  "validated",              default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "reviews", ["firm_id"], name: "index_reviews_on_firm_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"

  create_table "tests", force: :cascade do |t|
    t.string   "test_question"
    t.string   "test_long_question"
    t.string   "select_options"
    t.string   "positive_negative_switch"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "top_level_industries", force: :cascade do |t|
    t.string   "naf_code"
    t.string   "naf_title_fr"
    t.string   "naf_title_en"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "top_level_industries", ["naf_code"], name: "index_top_level_industries_on_naf_code"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
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
    t.string   "real_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
