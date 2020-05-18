FactoryBot.define do
  factory :list do
    genre
    user
    title { '作品タイトルA' }
    is_watched { true }
  end

  factory :other_list, class: List do
  	genre
    user
    title { '作品タイトルB' }
  end
end


# create_table "lists", force: :cascade do |t|
#   t.integer "user_id", null: false
#   t.string "title", null: false
#   t.integer "genre_id", null: false
#   t.datetime "start_time"
#   t.string "media"
#   t.float "rate"
#   t.text "impression"
#   t.boolean "is_watched", default: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end