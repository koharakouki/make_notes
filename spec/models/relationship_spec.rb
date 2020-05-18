require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'バリデーションのテスト' do
  	let!(:user) { create(:user) }
  	let!(:other_user) { create(:other_user) }
  	before do
  		@relationship = Relationship.new(follower_id: user.id, followed_id: other_user.id)
  	end

  	it '項目が存在していれば有効' do
  		expect(@relationship).to be_valid
  	end

  	it 'follower_idが存在していなければ無効' do
  		@relationship.follower_id = ''
  		expect(@relationship).to_not be_valid
  	end

  	it 'followed_idが存在していなければ無効' do
  		@relationship.followed_id = ''
  		expect(@relationship).to_not be_valid
  	end
  end
end
