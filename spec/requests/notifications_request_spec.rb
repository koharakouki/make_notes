require 'rails_helper'

RSpec.describe "NotificationsController", type: :request do
	let(:user){ create(:user) }
  let(:other_user){ create(:other_user) }
  before do
  	sign_in user
  end

  describe 'GET #index' do
  	it 'リクエストが成功すること' do
  		get notifications_url
  		expect(response.status).to eq 200
  	end

  	it '通知と表示されていること' do
  		get notifications_url
  		expect(response.body).to include "通知"
  	end
  end
end
