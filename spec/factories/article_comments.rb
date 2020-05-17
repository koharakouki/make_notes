FactoryBot.define do
  factory :article_comment do
    association :user
    association :article
    comment { Faker::Lorem.characters(number:20) }
  end
end


# create_table "article_comments", force: :cascade do |t|
#   t.integer "user_id"
#   t.integer "article_id"
#   t.text "content"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end