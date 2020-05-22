require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'バリデーションのテスト' do
    let!(:user) { create(:user) } # 通知する側のユーザー
    let!(:other_user) { create(:other_user) } # 通知される側のユーザー

    before do
      @notification = Notification.new(visiter_id: user.id,
                                       visited_id: other_user.id, action: 'follow')
    end

    it '項目が存在していれば有効' do
      expect(@notification).to be_valid
    end

    it 'visiter_idが存在していなければ無効' do
      @notification.visiter_id = ''
      expect(@notification).not_to be_valid
    end

    it 'visited_idが存在していなければ無効' do
      @notification.visited_id = ''
      expect(@notification).not_to be_valid
    end

    it 'actionが存在していなければ無効' do
      @notification.action = ''
      expect(@notification).not_to be_valid
    end
  end
end
