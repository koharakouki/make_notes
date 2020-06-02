require 'rails_helper'

RSpec.describe 'ユーザーのテスト', type: :feature do
  describe 'ユーザー新規登録' do
    let(:user) { build(:user) }

    before do
      visit new_user_registration_path
    end

    context '新規登録画面に遷移' do
      it '新規登録に成功する' do
        fill_in 'user[name]', with: user.name
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        fill_in 'user[password_confirmation]', with: user.password
        click_button '会員登録する'

        expect(page).to have_content "#{user.name}"
      end

      it '新規登録に失敗する' do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button '会員登録する'

        expect(page).to have_content 'ユーザーネームを入力してください'
      end
    end
  end

  describe 'ユーザーログイン' do
    let!(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context 'ログイン画面に遷移' do
      it 'ログインに成功する' do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'

        expect(page).to have_content "#{user.name}"
      end

      it 'ログインに失敗する' do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'

        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe 'ユーザー情報編集のテスト' do
    let(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context '自分の編集画面へ遷移' do
      it '遷移できる' do
        visit edit_user_path(user)

        expect(current_path).to eq('/users/' + user.id.to_s + '/edit')
      end
    end

    context '他人の編集画面へ遷移' do
      it '遷移できない' do
        visit edit_user_path(other_user)

        expect(current_path).to eq('/')
      end
    end
  end

  describe 'ユーザー一覧画面' do
    let(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ユーザー一覧画面へ遷移' do
      it '遷移できる' do
        find('#pc-users-link').click

        expect(current_path).to eq(users_path)
      end
    end

    context '他人のマイページへ遷移' do
      before do
        find('#pc-users-link').click
        click_link 'アリス', href: user_genres_path(other_user)
      end

      it '遷移できる' do
        expect(current_path).to eq(user_genres_path(other_user))
      end

      it 'カレンダー画面に遷移できる' do
        click_link 'カレンダー', href: calendar_user_path(other_user)

        expect(current_path).to eq(calendar_user_path(other_user))
      end
    end
  end
end
