FactoryBot.define do
  factory :favorite do
    association :user
    association :article
  end
end

# create_table "favorites", force: :cascade do |t|
#   t.integer "user_id"
#   t.integer "article_id"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end