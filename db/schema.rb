# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_16_075042) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followers", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_followers_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_followers_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_followers_on_follower_id"
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_blacklists_on_jti", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "list_name"
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_lists_on_post_id"
  end

  create_table "my_subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "amount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_my_subscriptions_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "topic"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reading_time"
    t.integer "status"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "age"
    t.string "address"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remaining_attempts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_remaining_attempts_on_user_id"
  end

  create_table "revisions", force: :cascade do |t|
    t.string "action"
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.string "title"
    t.string "topic"
    t.text "content"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_revisions_on_post_id"
    t.index ["user_id"], name: "index_revisions_on_user_id"
  end

  create_table "saved_posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_saved_posts_on_post_id"
    t.index ["user_id"], name: "index_saved_posts_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "max_posts_per_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_user_subscriptions_on_subscription_id"
    t.index ["user_id"], name: "index_user_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_votes_on_post_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "followers", "users", column: "followed_id"
  add_foreign_key "followers", "users", column: "follower_id"
  add_foreign_key "likes", "users"
  add_foreign_key "lists", "posts"
  add_foreign_key "my_subscriptions", "users"
  add_foreign_key "remaining_attempts", "users"
  add_foreign_key "saved_posts", "posts"
  add_foreign_key "saved_posts", "users"
  add_foreign_key "user_subscriptions", "subscriptions"
  add_foreign_key "user_subscriptions", "users"
  add_foreign_key "votes", "posts"
  add_foreign_key "votes", "users"
end
