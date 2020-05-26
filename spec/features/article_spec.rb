require 'rails_helper'

RSpec.describe '記事のテスト', type: :feature do
	let!(:user) { create(:user) }
	let(:article) { build(:article, user_id: user.id) }
	before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  context '記事追加のテスト' do
  	it '記事追加画面へ遷移' do
  		click_on '記事を書く'

  		expect(current_url).to eq(new_article_url)
  	end

  	it '記事を追加できる' do
  		click_on '記事を書く'
  		fill_in 'article[article_title]', with: article.article_title
  	  choose '有り'
  		fill_in 'article[content]', with: article.content
  		click_on '投稿する'

  		expect(page).to have_content article.article_title
  	end

  	it '追加できない' do
  		click_on '記事を書く'
  		fill_in 'article[article_title]', with: ''
  		choose '有り'
  		fill_in 'article[content]', with: ''
  		click_on '投稿する'

  		expect(page).to have_content '記事タイトルを入力してください。'
  	end
  end
end



