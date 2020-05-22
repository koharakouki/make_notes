require 'rails_helper'

RSpec.describe "FavoritesController", type: :request do
  let!(:user) { create(:user) }
  let!(:article) { create(:article, user_id: user.id) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'パラメータが正しい場合' do
      it 'リクエストが成功すること' do
        post article_favorites_url(article_id: article.id),
             params: { favorite: FactoryBot.attributes_for(:favorite) },
             xhr: true
        expect(response.status).to eq 200
      end

      it 'いいね数が増加すること' do
        expect do
          post article_favorites_url(article_id: article.id),
               params: { favorite: FactoryBot.attributes_for(:favorite) },
               xhr: true
        end.to change { Favorite.all.count }.by(1)
      end

      it '通知されること' do
        expect do
          post article_favorites_url(article_id: article.id),
               params: { favorite: FactoryBot.attributes_for(:favorite) },
               xhr: true
        end.to change { Notification.all.count }.by(1)
      end
    end

    context 'パラメータが不正の場合' do
      it 'リクエストが成功すること' do
        post article_favorites_url(article_id: article.id),
             params: { favorite: FactoryBot.attributes_for(:favorite, article_id: nil) },
             xhr: true
        expect(response.status).to eq 200
      end
    end
  end
end
