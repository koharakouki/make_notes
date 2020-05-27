require 'rails_helper'

RSpec.describe '管理者画面のテスト', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:article) { create(:article, user_id: user.id) }
  let!(:article_comment) { create(:article_comment, user_id: user.id, article_id: article.id) }

  describe '管理者ログイン' do
    before do
      visit new_admin_session_path
    end

    context 'チャート画面に遷移する' do
      it 'ログインに成功する' do
        fill_in 'admin[email]', with: admin.email
        fill_in 'admin[password]', with: admin.password
        click_button 'ログイン'

        expect(current_path).to eq('/admin')
      end

      it 'ログインに失敗する' do
        fill_in 'admin[email]', with: ''
        fill_in 'admin[password]', with: ''
        click_button 'ログイン'

        expect(current_path).to eq('/admins/sign_in')
      end
    end
  end

  describe 'ログイン後の画面' do
    before do
      visit new_admin_session_path
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
    end

    context 'ユーザー一覧画面' do
      it '遷移に成功する' do
        find('#pc-admin-users-link').click

        expect(current_path).to eq(admin_users_path)
      end

      it '検索に成功する' do
        find('#pc-admin-users-link').click
        fill_in 'q[name_cont]', with: 'ボブ'
        click_on '検索'

        expect(page).to have_content 'ボブ'
      end

      it '検索に失敗する' do
        find('#pc-admin-users-link').click
        fill_in 'q[name_cont]', with: 'あいうえお'
        click_on '検索'

        expect(page).to have_content '検索結果はありませんでした'
      end

      it '退会させることができる' do
        find('#pc-admin-users-link').click
        first('.user-delete').click

        expect(page).to have_content '退会済み'
      end

      it '記事一覧画面に遷移する' do
        find('#pc-admin-users-link').click
        find('#pc-admin-articles-link').click

        expect(current_path).to eq(admin_articles_path)
      end
    end

    context '記事一覧画面' do
      it '検索に成功する' do
        find('#pc-admin-articles-link').click
        fill_in 'q[article_title_cont]', with: article.article_title

        expect(page).to have_content article.article_title
      end

      it '検索に失敗する' do
        find('#pc-admin-articles-link').click
        fill_in 'q[article_title_cont]', with: 'あいうえお'
        click_on '検索'

        expect(page).to have_content '検索結果はありませんでした'
      end

      it '削除に成功する' do
        find('#pc-admin-articles-link').click
        first('.article-delete').click

        expect(page).not_to have_content article.article_title
      end

      it '記事詳細画面に遷移する' do
        find('#pc-admin-articles-link').click
        click_on 'タイトルタイトルタイトル'

        expect(page).to have_content 'タイトルタイトルタイトル'
      end
    end

    context '記事詳細画面' do
      it 'コメント削除に成功する' do
        find('#pc-admin-articles-link').click
        click_on 'タイトルタイトルタイトル'
        first('.article-comment-delete-link').click

        expect(page).not_to have_content 'コメントです'
      end

      it 'ログアウトに成功する' do
        find('#pc-admin-articles-link').click
        click_on 'タイトルタイトルタイトル'
        find('#pc-admin-logout-link').click

        expect(current_path).to eq(new_admin_session_path)
      end
    end
  end
end
