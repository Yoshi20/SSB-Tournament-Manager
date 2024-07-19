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

ActiveRecord::Schema[7.1].define(version: 2024_07_19_163230) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alternative_gamer_tags", force: :cascade do |t|
    t.bigint "player_id"
    t.string "gamer_tag"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "hidden", default: false
    t.string "country_code"
    t.index ["player_id"], name: "index_alternative_gamer_tags_on_player_id"
  end

  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "department"
    t.string "region"
    t.string "country_code"
    t.string "discord"
    t.string "twitter"
    t.string "instagram"
    t.string "facebook"
    t.string "youtube"
    t.string "twitch"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "telegram"
  end

  create_table "donations", force: :cascade do |t|
    t.string "message_id"
    t.string "timestamp"
    t.string "subtype"
    t.boolean "is_public"
    t.string "from_name"
    t.string "message"
    t.string "amount"
    t.string "url"
    t.string "email"
    t.string "currency"
    t.boolean "is_subscription_payment"
    t.boolean "is_first_subscription_payment"
    t.string "kofi_transaction_id"
    t.string "verification_token"
    t.string "shop_items"
    t.string "tier_name"
    t.string "country_code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "user_id"
    t.text "text"
    t.text "response"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "response_username"
    t.string "country_code"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "tournament_id"
    t.bigint "challonge_match_id"
    t.bigint "player1_id"
    t.bigint "player2_id"
    t.integer "player1_score"
    t.integer "player2_score"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "braacket_match_id"
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
  end

  create_table "news", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "teaser"
    t.text "text"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "country_code"
    t.index ["user_id"], name: "index_news_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "gamer_tag"
    t.integer "points"
    t.integer "participations"
    t.integer "self_assessment"
    t.integer "tournament_experience"
    t.text "comment"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.integer "best_rank"
    t.integer "wins"
    t.integer "losses"
    t.string "main_characters", default: [], array: true
    t.string "gender"
    t.integer "birth_year"
    t.string "prefix"
    t.string "discord_username"
    t.string "twitter_username"
    t.string "instagram_username"
    t.string "youtube_video_ids"
    t.integer "warnings"
    t.string "country_code"
    t.string "region"
    t.integer "main_character_skins", default: [], array: true
    t.string "smash_gg_id"
    t.string "nintendo_friend_code"
    t.string "twitch_username"
    t.string "gender_pronouns"
  end

  create_table "players_teams", id: false, force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "team_id", null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "tournament_id"
    t.integer "game_stations"
    t.float "paid_fee"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["player_id"], name: "index_results_on_player_id"
    t.index ["tournament_id"], name: "index_results_on_tournament_id"
  end

  create_table "shop_orders", force: :cascade do |t|
    t.string "organisation"
    t.string "name"
    t.string "address"
    t.string "address2"
    t.string "zip_code"
    t.string "city"
    t.string "phone_number"
    t.string "email", default: "", null: false
    t.boolean "was_order_paid", default: false
    t.datetime "order_paid_at"
    t.string "status", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shopping_cart_id"
    t.index ["shopping_cart_id"], name: "index_shop_orders_on_shopping_cart_id"
  end

  create_table "shop_products", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: ""
    t.string "currency"
    t.float "price", default: 0.0, null: false
    t.float "shipping", default: 0.0, null: false
    t.integer "stock", default: 0, null: false
    t.boolean "is_hidden", default: true
    t.integer "position"
    t.string "image_link"
    t.string "image_height"
    t.string "image_width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "country_code"
    t.index ["user_id"], name: "index_shop_products_on_user_id"
  end

  create_table "shop_purchases", force: :cascade do |t|
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.bigint "shopping_cart_id"
    t.string "stripe_account_id"
    t.index ["product_id"], name: "index_shop_purchases_on_product_id"
    t.index ["shopping_cart_id"], name: "index_shop_purchases_on_shopping_cart_id"
  end

  create_table "shop_seller_orders", force: :cascade do |t|
    t.boolean "was_order_sent", default: false
    t.datetime "order_sent_at"
    t.string "status", default: "", null: false
    t.string "stripe_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.bigint "user_id"
    t.index ["order_id"], name: "index_shop_seller_orders_on_order_id"
    t.index ["user_id"], name: "index_shop_seller_orders_on_user_id"
  end

  create_table "shopping_carts", force: :cascade do |t|
    t.string "client_ip"
    t.string "session_id"
    t.bigint "user_id"
    t.boolean "has_checked_out", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country_code"
  end

  create_table "survey_responses", force: :cascade do |t|
    t.integer "response"
    t.string "client_ip"
    t.string "country_code"
    t.boolean "is_hidden", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "survey_id"
    t.index ["survey_id"], name: "index_survey_responses_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "question"
    t.string "option1"
    t.string "option2"
    t.string "option3"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "name_long"
    t.string "name_short"
    t.string "description"
    t.string "website"
    t.string "discord"
    t.string "twitter"
    t.string "instagram"
    t.string "facebook"
    t.string "youtube"
    t.string "twitch"
    t.string "image_link"
    t.string "image_height"
    t.string "image_width"
    t.string "region"
    t.string "country_code"
    t.boolean "is_sponsoring_players"
    t.boolean "is_recruiting"
    t.string "recruiting_description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.integer "members_counter", default: 0
    t.string "telegram"
  end

  create_table "thredded_categories", force: :cascade do |t|
    t.bigint "messageboard_id", null: false
    t.text "name", null: false
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "slug", null: false
    t.index "lower(name) text_pattern_ops", name: "thredded_categories_name_ci"
    t.index ["messageboard_id", "slug"], name: "index_thredded_categories_on_messageboard_id_and_slug", unique: true
    t.index ["messageboard_id"], name: "index_thredded_categories_on_messageboard_id"
  end

  create_table "thredded_messageboard_groups", force: :cascade do |t|
    t.string "name"
    t.integer "position", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "country_code"
  end

  create_table "thredded_messageboard_notifications_for_followed_topics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "messageboard_id", null: false
    t.string "notifier_key", limit: 90, null: false
    t.boolean "enabled", default: true, null: false
    t.index ["user_id", "messageboard_id", "notifier_key"], name: "thredded_messageboard_notifications_for_followed_topics_unique", unique: true
  end

  create_table "thredded_messageboard_users", force: :cascade do |t|
    t.bigint "thredded_user_detail_id", null: false
    t.bigint "thredded_messageboard_id", null: false
    t.datetime "last_seen_at", precision: nil, null: false
    t.index ["thredded_messageboard_id", "last_seen_at"], name: "index_thredded_messageboard_users_for_recently_active"
    t.index ["thredded_messageboard_id", "thredded_user_detail_id"], name: "index_thredded_messageboard_users_primary", unique: true
  end

  create_table "thredded_messageboards", force: :cascade do |t|
    t.text "name", null: false
    t.text "slug"
    t.text "description"
    t.integer "topics_count", default: 0
    t.integer "posts_count", default: 0
    t.integer "position", null: false
    t.bigint "last_topic_id"
    t.bigint "messageboard_group_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "locked", default: false, null: false
    t.string "country_code"
    t.index ["messageboard_group_id"], name: "index_thredded_messageboards_on_messageboard_group_id"
    t.index ["slug"], name: "index_thredded_messageboards_on_slug", unique: true
  end

  create_table "thredded_notifications_for_followed_topics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifier_key", limit: 90, null: false
    t.boolean "enabled", default: true, null: false
    t.index ["user_id", "notifier_key"], name: "thredded_notifications_for_followed_topics_unique", unique: true
  end

  create_table "thredded_notifications_for_private_topics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifier_key", limit: 90, null: false
    t.boolean "enabled", default: true, null: false
    t.index ["user_id", "notifier_key"], name: "thredded_notifications_for_private_topics_unique", unique: true
  end

  create_table "thredded_post_moderation_records", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "messageboard_id"
    t.text "post_content"
    t.bigint "post_user_id"
    t.text "post_user_name"
    t.bigint "moderator_id"
    t.integer "moderation_state", null: false
    t.integer "previous_moderation_state", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["messageboard_id", "created_at"], name: "index_thredded_moderation_records_for_display", order: { created_at: :desc }
  end

  create_table "thredded_posts", force: :cascade do |t|
    t.bigint "user_id"
    t.text "content"
    t.string "source", limit: 191, default: "web"
    t.bigint "postable_id", null: false
    t.bigint "messageboard_id", null: false
    t.integer "moderation_state", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "country_code"
    t.index "to_tsvector('english'::regconfig, content)", name: "thredded_posts_content_fts", using: :gist
    t.index ["messageboard_id"], name: "index_thredded_posts_on_messageboard_id"
    t.index ["moderation_state", "updated_at"], name: "index_thredded_posts_for_display"
    t.index ["postable_id", "created_at"], name: "index_thredded_posts_on_postable_id_and_created_at"
    t.index ["postable_id"], name: "index_thredded_posts_on_postable_id"
    t.index ["user_id"], name: "index_thredded_posts_on_user_id"
  end

  create_table "thredded_private_posts", force: :cascade do |t|
    t.bigint "user_id"
    t.text "content"
    t.bigint "postable_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["postable_id", "created_at"], name: "index_thredded_private_posts_on_postable_id_and_created_at"
  end

  create_table "thredded_private_topics", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "last_user_id"
    t.text "title", null: false
    t.text "slug", null: false
    t.integer "posts_count", default: 0
    t.string "hash_id", limit: 20, null: false
    t.datetime "last_post_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["hash_id"], name: "index_thredded_private_topics_on_hash_id"
    t.index ["last_post_at"], name: "index_thredded_private_topics_on_last_post_at"
    t.index ["slug"], name: "index_thredded_private_topics_on_slug", unique: true
  end

  create_table "thredded_private_users", force: :cascade do |t|
    t.bigint "private_topic_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["private_topic_id"], name: "index_thredded_private_users_on_private_topic_id"
    t.index ["user_id"], name: "index_thredded_private_users_on_user_id"
  end

  create_table "thredded_topic_categories", force: :cascade do |t|
    t.bigint "topic_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_thredded_topic_categories_on_category_id"
    t.index ["topic_id"], name: "index_thredded_topic_categories_on_topic_id"
  end

  create_table "thredded_topics", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "last_user_id"
    t.text "title", null: false
    t.text "slug", null: false
    t.bigint "messageboard_id", null: false
    t.integer "posts_count", default: 0, null: false
    t.boolean "sticky", default: false, null: false
    t.boolean "locked", default: false, null: false
    t.string "hash_id", limit: 20, null: false
    t.integer "moderation_state", null: false
    t.datetime "last_post_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index "to_tsvector('english'::regconfig, title)", name: "thredded_topics_title_fts", using: :gist
    t.index ["hash_id"], name: "index_thredded_topics_on_hash_id"
    t.index ["last_post_at"], name: "index_thredded_topics_on_last_post_at"
    t.index ["messageboard_id"], name: "index_thredded_topics_on_messageboard_id"
    t.index ["moderation_state", "sticky", "updated_at"], name: "index_thredded_topics_for_display", order: { sticky: :desc, updated_at: :desc }
    t.index ["slug"], name: "index_thredded_topics_on_slug", unique: true
    t.index ["user_id"], name: "index_thredded_topics_on_user_id"
  end

  create_table "thredded_user_details", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "latest_activity_at", precision: nil
    t.integer "posts_count", default: 0
    t.integer "topics_count", default: 0
    t.datetime "last_seen_at", precision: nil
    t.integer "moderation_state", default: 0, null: false
    t.datetime "moderation_state_changed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["latest_activity_at"], name: "index_thredded_user_details_on_latest_activity_at"
    t.index ["moderation_state", "moderation_state_changed_at"], name: "index_thredded_user_details_for_moderations", order: { moderation_state_changed_at: :desc }
    t.index ["user_id"], name: "index_thredded_user_details_on_user_id", unique: true
  end

  create_table "thredded_user_messageboard_preferences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "messageboard_id", null: false
    t.boolean "follow_topics_on_mention", default: true, null: false
    t.boolean "auto_follow_topics", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "messageboard_id"], name: "thredded_user_messageboard_preferences_user_id_messageboard_id", unique: true
  end

  create_table "thredded_user_post_notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "notified_at", precision: nil, null: false
    t.index ["post_id"], name: "index_thredded_user_post_notifications_on_post_id"
    t.index ["user_id", "post_id"], name: "index_thredded_user_post_notifications_on_user_id_and_post_id", unique: true
  end

  create_table "thredded_user_preferences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "follow_topics_on_mention", default: true, null: false
    t.boolean "auto_follow_topics", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_thredded_user_preferences_on_user_id", unique: true
  end

  create_table "thredded_user_private_topic_read_states", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "postable_id", null: false
    t.integer "unread_posts_count", default: 0, null: false
    t.integer "read_posts_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.datetime "read_at", precision: nil, null: false
    t.index ["user_id", "postable_id"], name: "thredded_user_private_topic_read_states_user_postable", unique: true
  end

  create_table "thredded_user_topic_follows", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "reason", limit: 2
    t.index ["user_id", "topic_id"], name: "thredded_user_topic_follows_user_topic", unique: true
  end

  create_table "thredded_user_topic_read_states", force: :cascade do |t|
    t.bigint "messageboard_id", null: false
    t.bigint "user_id", null: false
    t.bigint "postable_id", null: false
    t.integer "unread_posts_count", default: 0, null: false
    t.integer "read_posts_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.datetime "read_at", precision: nil, null: false
    t.index ["messageboard_id"], name: "index_thredded_user_topic_read_states_on_messageboard_id"
    t.index ["user_id", "messageboard_id"], name: "thredded_user_topic_read_states_user_messageboard"
    t.index ["user_id", "postable_id"], name: "thredded_user_topic_read_states_user_postable", unique: true
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.datetime "date", precision: nil
    t.string "location"
    t.text "description"
    t.float "registration_fee"
    t.integer "total_seats"
    t.boolean "active"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "started"
    t.boolean "finished"
    t.bigint "challonge_tournament_id"
    t.string "ranking_string"
    t.boolean "setup"
    t.datetime "registration_deadline", precision: nil
    t.string "host_username"
    t.string "waiting_list", default: [], array: true
    t.string "subtype"
    t.string "city"
    t.datetime "end_date", precision: nil
    t.string "external_registration_link"
    t.integer "total_needed_game_stations"
    t.integer "min_needed_registrations"
    t.boolean "is_registration_allowed", default: true
    t.integer "number_of_pools", default: 0
    t.string "image_link"
    t.string "image_height"
    t.string "image_width"
    t.string "country_code"
    t.string "region"
    t.bigint "smash_gg_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.boolean "allows_emails_from_swisssmash", default: true
    t.boolean "allows_emails_from_partners", default: true
    t.boolean "allows_emails_from_germanysmash", default: true
    t.string "country_code"
    t.boolean "allows_emails_from_francesmash", default: true
    t.boolean "allows_emails_from_luxsmash", default: true
    t.boolean "allows_emails_from_italysmash", default: true
    t.boolean "allows_emails_from_uksmash", default: true
    t.boolean "allows_emails_from_portugalsmash", default: true
    t.boolean "allows_emails_from_smashiceland", default: true
    t.string "stripe_account_id"
    t.boolean "stripe_account_is_ready", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "communities", "users"
  add_foreign_key "players", "users"
  add_foreign_key "shop_orders", "shopping_carts"
  add_foreign_key "shop_products", "users"
  add_foreign_key "shop_purchases", "shop_products", column: "product_id"
  add_foreign_key "shop_purchases", "shopping_carts"
  add_foreign_key "shop_seller_orders", "shop_orders", column: "order_id"
  add_foreign_key "shop_seller_orders", "users"
  add_foreign_key "survey_responses", "surveys"
  add_foreign_key "taggings", "tags"
  add_foreign_key "teams", "users"
  add_foreign_key "thredded_messageboard_users", "thredded_messageboards", on_delete: :cascade
  add_foreign_key "thredded_messageboard_users", "thredded_user_details", on_delete: :cascade
  add_foreign_key "thredded_user_post_notifications", "thredded_posts", column: "post_id", on_delete: :cascade
  add_foreign_key "thredded_user_post_notifications", "users", on_delete: :cascade
end
