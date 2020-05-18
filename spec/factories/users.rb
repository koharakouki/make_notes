FactoryBot.define do
  factory :user do
    name { 'ボブ' }
    sequence(:email) { |n| "user_#{n}@exmaple.com"}
    introduction { Faker::Lorem.characters(number:20) }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :other_user, class: User do
    name { 'アリス' }
    sequence(:email) { |n| "other_user_#{n}@exmaple.com"}
    introduction { Faker::Lorem.characters(number:20) }
    password { '000000' }
    password_confirmation { '000000' }
  end
end

# create_table "users", force: :cascade do |t|
#   t.string "email", default: "", null: false
#   t.string "encrypted_password", default: "", null: false
#   t.string "reset_password_token"
#   t.datetime "reset_password_sent_at"
#   t.datetime "remember_created_at"
#   t.string "name"
#   t.text "introduction"
#   t.string "image_id"
#   t.string "uid"
#   t.string "provider"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.datetime "deleted_at"
#   t.index ["deleted_at"], name: "index_users_on_deleted_at"
#   t.index ["email"], name: "index_users_on_email", unique: true
#   t.index ["name"], name: "index_users_on_name", unique: true
#   t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
# end