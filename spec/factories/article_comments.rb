FactoryBot.define do
  factory :article_comment do
    article
    user
    content { "コメントです" }
  end
end

# create_table "article_comments", force: :cascade do |t|
#   t.integer "user_id"
#   t.integer "article_id"
#   t.text "content"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end
