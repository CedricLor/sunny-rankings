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

ActiveRecord::Schema.define(version: 20150624175237) do

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
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "firms", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "address"
    t.string   "country"
    t.integer  "headcount"
    t.text     "business_description"
    t.string   "industry"
    t.string   "icon_name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "granted_awards", force: :cascade do |t|
    t.integer  "award_id"
    t.integer  "firm_id"
    t.text     "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "granted_awards", ["award_id"], name: "index_granted_awards_on_award_id"
  add_index "granted_awards", ["firm_id"], name: "index_granted_awards_on_firm_id"

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
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "firm_id"
    t.string   "user_firm_relationship"
    t.string   "temporary_email"
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
    t.integer  "profile_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["profile_id"], name: "index_users_on_profile_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
