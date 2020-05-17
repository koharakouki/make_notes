FactoryBot.define do
  factory :genre do
    association :user
    name { 'ジャンル名' }
  end
end

# create_table "genres", force: :cascade do |t|
#   t.integer "user_id"
#   t.string "name"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end