require 'rails_helper'

RSpec.describe "ArticlesController", type: :request do
  let!(:user) { create(:user) }

  describe 'GET #new' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get new_article_url
        expect(response.status).to eq 200
      end

      it '記事を書く表示されていること' do
        get new_article_url
        expect(response.body).to include "記事を書く"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが成功すること' do
        get new_article_url
        expect(response.status).to eq 302
      end
    end
  end

  describe 'POST #create' do
    before do
      sign_in user
    end

    context 'パラメータが正しい場合' do
      it 'リクエストが成功すること' do
        post articles_url,
             params: { article: FactoryBot.attributes_for(:article) }
        expect(response.status).to eq 302
      end

      it '記事が投稿されること' do
        expect do
          post articles_url,
               params: { article: FactoryBot.attributes_for(:article) }
        end.to change { Article.all.count }.by(1)
      end

      it 'リダイレクトされること' do
        post articles_url,
             params: { article: FactoryBot.attributes_for(:article) }
        expect(response).to redirect_to articles_url
      end
    end

    context 'パラメータが不正の場合' do
      it 'リクエストが成功すること' do
        post articles_url,
             params: { article: FactoryBot.attributes_for(:article, article_title: nil) }
        expect(response.status).to eq 200
      end

      it '記事が投稿されないこと' do
        expect do
          post articles_url,
               params: { article: FactoryBot.attributes_for(:article, article_title: nil) }
        end.not_to change { Article.all.count }
      end

      it 'エラーが表示されること' do
        post articles_url,
             params: { article: FactoryBot.attributes_for(:article, article_title: nil) }
        expect(response.body).to include "記事タイトルを入力してください"
      end
    end
  end

  describe 'GET #index' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get articles_url
        expect(response.status).to eq 200
      end

      it '記事を探すと表示されていること' do
        get articles_url
        expect(response.body).to include "記事を探す"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが成功すること' do
        get articles_url
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }
    let!(:article) { create(:article, user_id: user.id) }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get article_url(article.id)
        expect(response.status).to eq 200
      end

      it '記事のタイトルが表示されていること' do
        get article_url(article.id)
        expect(response.body).to include "#{article.article_title}"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが成功すること' do
        get article_url(article.id)
        expect(response.status).to eq 302
      end
    end
  end
end
