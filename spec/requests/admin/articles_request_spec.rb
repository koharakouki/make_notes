require 'rails_helper'

RSpec.describe "Admin::ArticlesController", type: :request do
	let!(:admin) { create(:admin) }
	describe 'GET #index' do
		context 'ログインしている場合' do
			before do
				sign_in admin
			end

			it 'リクエストに成功すること' do
				get admin_articles_url
				expect(response.status).to eq 200
			end

			it '記事一覧と表示されていること' do
				get admin_articles_url
				expect(response.body).to include "記事一覧"
			end
		end

		context 'ログインしていない場合' do
			it 'リクエストに成功すること' do
				get admin_articles_url
				expect(response.status).to eq 302
			end
		end
	end


	describe 'GET #show' do
		let!(:user) { create(:user) }
		let!(:article) { create(:article, user_id: user.id) }
		context 'ログインしている場合' do
			before do
				sign_in admin
			end

			it 'リクエストに成功すること' do
				get admin_article_url(article.id)
				expect(response.status).to eq 200
			end

			it '記事タイトルが表示されていること' do
				get admin_article_url(article.id)
				expect(response.body).to include "#{article.article_title}"
			end
		end

		context 'ログインしていない場合' do
			it 'リクエストに成功すること' do
				get admin_article_url(article.id)
				expect(response.status).to eq 302
			end
		end
	end


	describe 'DELETE "destroy' do
		let!(:user) { create(:user) }
		let!(:article) { create(:article, user_id: user.id) }
		before do
			sign_in admin
		end

		it 'リクエストに成功すること' do
			delete admin_article_url(article.id)
			expect(response.status).to eq 302
		end

		it 'ユーザーが削除されること' do
			expect do
				delete admin_article_url(article.id)
			end.to change { Article.all.count }.by(-1)
		end
	end
end
