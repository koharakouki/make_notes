FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "user_#{n}@exmaple.com"}
    introduction { Faker::Lorem.characters(number:20) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end


  # create_table "admins", force: :cascade do |t|
  #   t.string "email", default: "", null: false
  #   t.string "encrypted_password", default: "", null: false
  #   t.string "reset_password_token"
  #   t.datetime "reset_password_sent_at"
  #   t.datetime "remember_created_at"
  #   t.datetime "created_at", null: false
  #   t.datetime "updated_at", null: false
  #   t.index ["email"], name: "index_admins_on_email", unique: true
  #   t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  # end