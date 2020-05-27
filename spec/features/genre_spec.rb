require 'rails_helper'

RSpec.describe 'ジャンルのテスト', type: :feature do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  context 'ジャンルの追加' do
    it '追加できる' do
      fill_in 'genre[name]', with: "映画"
      click_on '追加'

      expect(page).to have_content "映画"
    end

    it '追加できない' do
      fill_in 'genre[name]', with: ""
      click_on '追加'

      expect(page).to have_content "ジャンル名を入力してください。"
    end
  end
end
