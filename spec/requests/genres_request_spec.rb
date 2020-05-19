require 'rails_helper'

RSpec.describe "Genres", type: :request do
	let!(:user) { create(:user) }

  describe "GET #index" do
  	context 'ログインしている場合' do
  		before do
  			sign_in user
  		end

	    it "リクエストが成功すること" do
	      get user_genres_path(user_id: user.id)
	      expect(response.status).to eq 200
	    end

	    it 'マイリストと表示されていること' do
	    	get user_genres_path(user_id: user.id)
	    	expect(response.body).to include "マイリスト"
	    end
	  end
  end

  context 'ログインしていない場合' do
  	it 'リクエストが失敗すること' do
  		get user_genres_path(user_id: user.id)
  		expect(response.status).to eq 302
  	end
  end


  describe 'POST #create' do
  	before do
  		sign_in user
  	end

    context '正常なパラメータの場合' do
    	it 'リクエストが成功すること' do
    		post user_genres_path(user_id: user.id),
    		params: { genre: FactoryBot.attributes_for(:genre, user_id: user.id) }
    		expect(response.status).to eq 302
    	end

    	it 'ジャンルが追加されること' do
    		expect do
    			post user_genres_path(user_id: user.id),
    		  params: { genre: FactoryBot.attributes_for(:genre, user_id: user.id) }
    		end.to change { Genre.all.count }.by(1)
    	end
    end

    context '不正なパラメータの場合' do
    	it 'リクエストが成功すること' do
    		post user_genres_path(user_id: user.id),
    		params: { genre: FactoryBot.attributes_for(:genre, name: nil, user_id: user.id) }
    		expect(response.status).to eq 200
    	end

    	it 'ジャンルが追加されないこと' do
    		expect do
    			post user_genres_path(user_id: user.id),
    		  params: { genre: FactoryBot.attributes_for(:genre, name: nil, user_id: user.id) }
    		end.to_not change { Genre.all.count }
    	end

    	it 'エラーが表示されること' do
    		post user_genres_path(user_id: user.id),
    		params: { genre: FactoryBot.attributes_for(:genre, name: nil, user_id: user.id) }
    		expect(response.body).to include "ジャンル名を入力してください"
    	end
    end
  end


  describe 'DELETE #destroy' do
  	let!(:user) { create(:user) }
  	let!(:genre) { create(:genre, user_id: user.id, name: '映画') }
  	before do
  		sign_in user
  	end

  	it 'リクエストが成功すること' do
  		delete user_genre_path(user_id: user.id, id: genre.id)
  		expect(response.status).to eq 302
  	end

  	it 'ジャンルが削除されること' do
  		expect do
  			delete user_genre_path(user_id: user.id, id: genre.id)
  		end.to change { Genre.all.count }.by(-1)
  	end
  end
end
