FactoryBot.define do
  factory :article do
    association :user
    article_title { 'タイトルタイトルタイトル' }
    content { '本文本文本文本文本文本文本文本文本文本文' }
    is_spoiler { true }
  end
end

# create_table "articles", force: :cascade do |t|
#   t.integer "user_id"
#   t.string "article_title"
#   t.text "content"
#   t.boolean "is_spoiler", default: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end