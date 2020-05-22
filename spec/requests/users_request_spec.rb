require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  describe 'GET #index' do
    let!(:user) { create(:user) }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get users_url
        expect(response.status).to eq 200
      end

      it '「ユーザーを探す」と表示されていること' do
        get users_url
        expect(response.body).to include "ユーザーを探す"
      end

      it 'ユーザー名が表示されていること' do
        get users_url
        expect(response.body).to include "ボブ"
      end

      it 'オススメのフォロワーが表示されていること' do
        get users_url
        expect(response.body).to include "おすすめユーザー"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが失敗すること' do
        get users_url
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #edit' do
    let!(:user) { create(:user) }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get edit_user_url(user)
        expect(response.status).to eq 200
      end

      it 'アカウント情報を変更と表示されていること' do
        get edit_user_url(user)
        expect(response.body).to include "アカウント情報を変更"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが失敗すること' do
        get edit_user_url(user)
        expect(response.status).to eq 302
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create(:user) }

    before do
      sign_in user
    end

    context '正常なパラメータの場合' do
      it 'リクエストが成功すること' do
        patch user_url(user), params: { user: attributes_for(:other_user) }
        expect(response.status).to eq 302
      end

      it 'ユーザー名が更新されること' do
        expect do
          patch user_url(user), params: { user: attributes_for(:other_user) }
        end.to change { User.find(user.id).name }.from("ボブ").to("アリス")
      end

      it 'リダイレクトすること' do
        patch user_url(user), params: { user: attributes_for(:other_user) }
        expect(response).to redirect_to user_genres_path(user)
      end
    end

    context '不正なパラメータの場合' do
      it 'リクエストが成功すること' do
        patch user_url(user), params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.status).to eq 200
      end

      it 'ユーザー名が更新されないこと' do
        expect do
          patch user_url(user), params: { user: FactoryBot.attributes_for(:user, :invalid) }
        end.not_to change { User.find(user.id).name }
      end

      it 'エラーが表示されること' do
        patch user_url(user), params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.body).to include "ユーザーネームを入力してください"
      end
    end
  end

  describe 'GET #following' do
    let!(:user) { create(:user) }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get following_user_url(user)
        expect(response.status).to eq 200
      end

      it '見出しが表示されていること' do
        get following_user_url(user)
        expect(response.body).to include "#{user.name}さんがフォロー中のユーザー"
      end

      it 'おすすめユーザーが表示されていること' do
        get following_user_url(user)
        expect(response.body).to include "おすすめユーザー"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが失敗すること' do
        get following_user_url(user)
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #followers' do
    let!(:user) { create(:user) }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get followers_user_url(user)
        expect(response.status).to eq 200
      end

      it '見出しが表示されていること' do
        get followers_user_url(user)
        expect(response.body).to include "#{user.name}さんをフォローしているユーザー"
      end

      it 'おすすめユーザーが表示されていること' do
        get followers_user_url(user)
        expect(response.body).to include "おすすめユーザー"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが失敗すること' do
        get followers_user_url(user)
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #calendar' do
    let!(:user) { create(:user) }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'リクエストが成功すること' do
        get calendar_user_url(user)
        expect(response.status).to eq 200
      end

      it '見出しが表示されていること' do
        get calendar_user_url(user)
        expect(response.body).to include "#{user.name}さんのカレンダー"
      end

      it 'チャートが表示されていること' do
        get calendar_user_url(user)
        expect(response.body).to include "これまでに見たジャンル割合"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストに失敗すること' do
        get calendar_user_url(user)
        expect(response.status).to eq 302
      end
    end
  end
end
