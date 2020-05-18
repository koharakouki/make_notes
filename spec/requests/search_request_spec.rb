require 'rails_helper'

RSpec.describe "SearchesController", type: :request do
	describe 'GET #search(users)' do
		let!(:user) { create(:user) }

		context 'ログインしている場合' do
			before do
				sign_in user
			end

			it 'リクエストに成功すること' do
				get search_path(model: "user", search: "あいうえお")
				expect(response.status).to eq 200
			end

			it 'ユーザーを探すと表示されていること' do
				get search_path(model: "user", search: "あいうえお")
				expect(response.body).to include "ユーザーを探す"
			end

		  it 'ユーザー名が表示されていること' do
	  		get search_path(model: "user", search: "あいうえお")
	  		expect(response.body).to include "#{user.name}"
	  	end

	  	it 'おすすめのユーザーが表示されていること' do
	  		get search_path(model: "user", search: "あいうえお")
	  		expect(response.body).to include "おすすめユーザー"
	  	end
	  end

	  context 'ログインしていない場合' do
	  	it 'リクエストに失敗すること' do
	  		get search_path(model: "user", search: "あいうえお")
	  		expect(response.status).to eq 302
	  	end
	  end
	end


	describe 'GET #search(articles)' do
		let!(:user) { create(:user) }

		context 'ログインしている場合' do
			before do
				sign_in user
			end

			it 'リクエストに成功すること' do
				get search_path(model: "article", search: "あいうえお")
				expect(response.status).to eq 200
			end

			it '記事を探すと表示されていること' do
				get search_path(model: "article", search: "あいうえお")
				expect(response.body).to include "記事を探す"
			end

			it 'ユーザー名が表示されていること' do
				get search_path(model: "article", search: "あいうえお")
				expect(response.body).to include "#{user.name}"
			end
	  end

	  context 'ログインしていない場合' do
	  	it 'リクエストに失敗すること' do
	  		get search_path(model: "article", search: "あいうえお")
	  		expect(response.status).to eq 302
	  	end
	  end
	end
end
