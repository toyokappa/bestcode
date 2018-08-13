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

ActiveRecord::Schema.define(version: 2018_08_13_130010) do

  create_table "languages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "participating_room_id"
    t.bigint "reviewee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participating_room_id"], name: "index_participations_on_participating_room_id"
    t.index ["reviewee_id"], name: "index_participations_on_reviewee_id"
  end

  create_table "pulls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "url"
    t.integer "number"
    t.boolean "is_open", default: false, null: false
    t.bigint "repo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repo_id"], name: "index_pulls_on_repo_id"
  end

  create_table "repos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "full_name"
    t.text "description"
    t.string "url"
    t.boolean "is_private", default: false, null: false
    t.boolean "is_visible", default: false, null: false
    t.bigint "user_id"
    t.datetime "pushed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_hook", default: false, null: false
    t.index ["user_id"], name: "index_repos_on_user_id"
  end

  create_table "review_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "body"
    t.string "state", default: "commented", null: false
    t.integer "user_id"
    t.integer "review_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_request_id"], name: "index_review_comments_on_review_request_id"
    t.index ["user_id"], name: "index_review_comments_on_user_id"
  end

  create_table "review_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_open", default: true, null: false
    t.string "state", default: "wait_review", null: false
    t.integer "pull_id"
    t.integer "reviewee_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pull_id"], name: "index_review_requests_on_pull_id"
    t.index ["reviewee_id"], name: "index_review_requests_on_reviewee_id"
    t.index ["room_id"], name: "index_review_requests_on_room_id"
  end

  create_table "rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "capacity"
    t.bigint "reviewer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_open", default: true, null: false
    t.string "image"
    t.index ["reviewer_id"], name: "index_rooms_on_reviewer_id"
  end

  create_table "skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "language_id"
    t.string "languageable_type"
    t.bigint "languageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_skills_on_language_id"
    t.index ["languageable_type", "languageable_id"], name: "index_skills_on_languageable_type_and_languageable_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "email"
    t.integer "contribution", default: 0, null: false
    t.boolean "is_reviewer", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
    t.string "image"
    t.boolean "is_first_time", default: true, null: false
    t.string "header_image"
  end

  add_foreign_key "pulls", "repos"
  add_foreign_key "repos", "users"
  add_foreign_key "rooms", "users", column: "reviewer_id"
end
