require 'rails_helper'

RSpec.describe 'ユーザー認証のテスト', type: :feature do
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
end

describe 'ユーザーのテスト' do
	let(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }
  before do
  	visit new_user_session_path
  	fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  describe '編集のテスト' do
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
end


