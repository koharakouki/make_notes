require 'rails_helper'

RSpec.describe "ListsController", type: :request do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre, user_id: user.id, name: '映画') }

  describe 'GET #want' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get want_url(user_id: user.id)
        expect(response.status).to eq 200
      end

      it 'ユーザー名が表示されること' do
        get want_url(user_id: user.id)
        expect(response.body).to include "#{user.name}"
      end

      it '観たいへ追加ボタンが表示されること' do
        get want_url(user_id: user.id)
        expect(response.body).to include "観たいへ追加"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが失敗すること' do
        get want_url(user_id: user.id)
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #done' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get done_url(user_id: user.id)
        expect(response.status).to eq 200
      end

      it 'ユーザー名が表示されること' do
        get done_url(user_id: user.id)
        expect(response.body).to include "#{user.name}"
      end

      it 'テーブルに評価欄が表示されること' do
        get done_url(user_id: user.id)
        expect(response.body).to include "評価"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが失敗すること' do
        get done_url(user_id: user.id)
        expect(response.status).to eq 302
      end
    end
  end

  describe 'POST #create' do
    before do
      sign_in user
    end

    context '正常なパラメータの場合' do
      it 'リクエストが成功すること' do
        post user_lists_url(user_id: user.id),
             params: {
               list: FactoryBot.attributes_for(:other_list,
                                               user_id: user.id,
                                               genre_id: genre.id),
               user_id: user.id, add_want: "want",
             }, xhr: true
        expect(response.status).to eq 200
      end

      it '観たいリストに追加されること' do
        expect do
          post user_lists_url(user_id: user.id),
               params: {
                 list: FactoryBot.attributes_for(:other_list,
                                                 user_id: user.id,
                                                 genre_id: genre.id),
                 user_id: user.id, add_want: "want",
               }, xhr: true
        end.to change { List.all.count }.by(1)
      end
    end

    context '不正なパラメータの場合' do
      it 'リクエストが成功すること' do
        post user_lists_url(user_id: user.id),
             params: {
               list: FactoryBot.attributes_for(:other_list,
                                               title: nil,
                                               user_id: user.id,
                                               genre_id: genre.id),
               user_id: user.id, add_want: "want",
             }, xhr: true
        expect(response.status).to eq 200
      end

      it 'リストに登録されないこと' do
        expect do
          post user_lists_url(user_id: user.id),
               params: {
                 list: FactoryBot.attributes_for(:other_list,
                                                 title: nil,
                                                 user_id: user.id,
                                                 genre_id: genre.id),
                 user_id: user.id, add_want: "want",
               }, xhr: true
        end.to change { List.all.count }.by(0)
      end

      it 'エラーが表示されること' do
        post user_lists_url(user_id: user.id),
             params: {
               list: FactoryBot.attributes_for(:other_list,
                                               title: nil,
                                               user_id: user.id,
                                               genre_id: genre.id),
               user_id: user.id, add_want: "want",
             }, xhr: true
        expect(response.body).to include "Titleを入力してください"
      end
    end
  end

  describe 'GET #show' do
    let!(:list) { create(:list, user_id: user.id, genre_id: genre.id) }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get user_list_url(user_id: user.id, id: list.id)
        expect(response.status).to eq 200
      end

      it 'リストのタイトルが表示されていること' do
        get user_list_url(user_id: user.id, id: list.id)
        expect(response.body).to include "#{list.title}"
      end

      it '新着記事が表示されていること' do
        get user_list_url(user_id: user.id, id: list.id)
        expect(response.body).to include "新着記事"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが失敗すること' do
        get user_list_url(user_id: user.id, id: list.id)
        expect(response.status).to eq 302
      end
    end
  end

  describe 'PATCH #update' do
    let!(:list) { create(:list, user_id: user.id, genre_id: genre.id) }

    before do
      sign_in user
    end

    context '正常なパラメータの場合' do
      it 'リクエストが成功すること(showページからの更新)' do
        patch user_list_url(user_id: user.id, id: list.id),
              params: {
                list: FactoryBot.attributes_for(:other_list_a,
                                                user_id: user.id,
                                                genre_id: genre.id),
                list_id: list.id,
              }
        expect(response.status).to eq 302
      end

      it '作品タイトルが更新されること' do
        expect do
          patch user_list_url(user_id: user.id, id: list.id),
                params: {
                  list: FactoryBot.attributes_for(:other_list_a,
                                                  user_id: user.id,
                                                  genre_id: genre.id),
                  list_id: list.id,
                }
        end.to change { List.find(list.id).title }.from('作品タイトルA').to('作品タイトルC')
      end

      it 'リダイレクトされること' do
        patch user_list_url(user_id: user.id, id: list.id),
              params: {
                list: FactoryBot.attributes_for(:other_list_a,
                                                user_id: user.id,
                                                genre_id: genre.id),
                list_id: list.id,
              }
        expect(response).to redirect_to user_list_url(user_id: list.user.id, id: list.id)
      end
    end

    context '不正なパラメータの場合' do
      it 'リクエストが成功すること' do
        patch user_list_url(user_id: user.id, id: list.id),
              params: {
                list: FactoryBot.attributes_for(:other_list_a,
                                                :invalid,
                                                user_id: user.id,
                                                genre_id: genre.id),
                list_id: list.id,
              }
        expect(response.status).to eq 200
      end

      it 'Titleが更新されないこと' do
        expect do
          patch user_list_url(user_id: user.id, id: list.id),
                params: {
                  list: FactoryBot.attributes_for(:other_list_a,
                                                  :invalid,
                                                  user_id: user.id,
                                                  genre_id: genre.id),
                  list_id: list.id,
                }
        end.not_to change { List.find(list.id).title }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:list) { create(:list, user_id: user.id, genre_id: genre.id) }

    before do
      sign_in user
    end

    it 'リクエストが成功すること' do
      delete user_list_url(user_id: user.id, id: list.id), xhr: true
      expect(response.status).to eq 200
    end

    it 'リストが削除されること' do
      expect do
        delete user_list_url(user_id: user.id, id: list.id), xhr: true
      end.to change { List.all.count }.by(-1)
    end
  end
end
