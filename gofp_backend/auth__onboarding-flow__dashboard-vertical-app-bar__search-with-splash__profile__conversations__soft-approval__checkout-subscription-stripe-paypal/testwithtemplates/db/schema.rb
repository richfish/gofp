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

ActiveRecord::Schema.define(version: 20160215225705) do

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

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "assets", force: :cascade do |t|
    t.string   "caption"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "assets", ["owner_type", "owner_id"], name: "index_assets_on_owner_type_and_owner_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "message"
    t.boolean  "flagged",          default: false
    t.boolean  "read",             default: false
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "converser_id"
    t.integer  "conversant_id"
    t.boolean  "flagged"
    t.integer  "comments_count"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "ipn_notifications", force: :cascade do |t|
    t.string   "payment_status"
    t.string   "payment_date"
    t.string   "payer_email"
    t.string   "payer_id"
    t.string   "receiver_email"
    t.string   "txn_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mc_gross"
    t.string   "mc_fee"
    t.string   "mc_currency"
    t.string   "custom"
    t.string   "payment_gross"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "issues", force: :cascade do |t|
    t.text     "description"
    t.boolean  "resolved",       default: false
    t.integer  "issueable_id"
    t.string   "issueable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["issueable_type", "issueable_id"], name: "index_issues_on_issueable_type_and_issueable_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.string   "stripe_token"
    t.integer  "amount_cents"
    t.string   "stripe_customer_hash"
    t.string   "paypal_identifier"
    t.string   "paypal_payer_id"
    t.boolean  "paypal"
    t.boolean  "stripe"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "fee_cents"
    t.boolean  "unsubscribed"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status"
    t.boolean  "flagged"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "search_entity_subscriptions", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_subscriptions", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "orders", "users"
  add_foreign_key "profiles", "users"
end
