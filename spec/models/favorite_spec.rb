require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'バリデーションのテスト' do
  	let!(:favorite) { create(:favorite) }

  	it '項目が存在していれば有効' do
  		expect(favorite).to be_valid
  	end

  	it 'user_idが存在していなければ無効' do
  		favorite.user_id = ''
  		expect(favorite).to_not be_valid
  	end

  	it 'article_idが存在していなければ無効' do
  		favorite.article_id = ''
  		expect(favorite).to_not be_valid
  	end
  end
end
