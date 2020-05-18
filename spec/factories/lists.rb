FactoryBot.define do
  factory :list do
    genre
    user { genre.user }
    title { 'タイトル' }
    is_watched { true }
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