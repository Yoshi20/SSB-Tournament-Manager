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

ActiveRecord::Schema.define(version: 2019_07_22_231800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alternative_gamer_tags", force: :cascade do |t|
    t.bigint "player_id"
    t.string "gamer_tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_alternative_gamer_tags_on_player_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "user_id"
    t.text "text"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "response_username"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "tournament_id"
    t.bigint "challonge_match_id"
    t.bigint "player1_id"
    t.bigint "player2_id"
    t.integer "player1_score"
    t.integer "player2_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "braacket_match_id"
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "gamer_tag"
    t.integer "points"
    t.integer "participations"
    t.integer "self_assessment"
    t.integer "tournament_experience"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "best_rank"
    t.integer "wins"
    t.integer "losses"
    t.string "main_characters", default: [], array: true
    t.string "canton"
    t.string "gender"
    t.integer "birth_year"
    t.string "prefix"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "tournament_id"
    t.integer "game_stations"
    t.float "paid_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_registrations_on_player_id"
    t.index ["tournament_id"], name: "index_registrations_on_tournament_id"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "tournament_id"
    t.string "major_name"
    t.integer "rank"
    t.integer "points"
    t.string "city"
    t.integer "wins"
    t.integer "losses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_results_on_player_id"
    t.index ["tournament_id"], name: "index_results_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.datetime "date"
    t.string "location"
    t.text "description"
    t.float "registration_fee"
    t.integer "total_seats"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "started"
    t.boolean "finished"
    t.bigint "challonge_tournament_id"
    t.string "ranking_string"
    t.boolean "setup"
    t.datetime "registration_deadline"
    t.string "host_username"
    t.string "waiting_list", default: [], array: true
    t.string "subtype"
    t.string "city"
    t.datetime "end_date"
    t.string "external_registration_link"
    t.integer "total_needed_game_stations"
    t.integer "min_needed_registrations"
    t.boolean "is_registration_allowed", default: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "is_admin"
    t.string "challonge_username"
    t.string "challonge_api_key"
    t.boolean "is_super_admin"
    t.string "full_name"
    t.string "mobile_number"
    t.string "area_of_responsibility"
    t.boolean "is_club_member", default: false
    t.boolean "wants_major_email", default: true
    t.boolean "wants_weekly_email", default: true
    t.string "discord_username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "players", "users"
end
