require 'rails_helper'

RSpec.describe "Admin::UsersController", type: :request do
  let!(:admin) { create(:admin) }

  describe 'GET #index' do
    context 'ログインしている場合' do
      before do
        sign_in admin
      end

      it 'リクエストに成功すること' do
        get admin_users_url
        expect(response.status).to eq 200
      end

      it 'ユーザー一覧と表示されていること' do
        get admin_users_url
        expect(response.body).to include "ユーザー一覧"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストに成功すること' do
        get admin_users_url
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #chart' do
    context 'ログインしている場合' do
      before do
        sign_in admin
      end

      it 'リクエストに成功すること' do
        get admin_root_url
        expect(response.status).to eq 200
      end

      it 'チャートと表示されること' do
        get admin_root_url
        expect(response.body).to include "チャート"
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストに成功すること' do
        get admin_root_url
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }

    before do
      sign_in admin
    end

    it 'リクエストに成功すること' do
      delete admin_user_url(user.id)
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete admin_user_url(user.id)
      end.to change { User.all.count }.by(-1)
    end
  end
end
