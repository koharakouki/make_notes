require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'バリデーションのテスト' do
  	let!(:genre) { create(:genre) }

  	it '項目が存在すれば有効' do
  		expect(genre).to be_valid
  	end

  	it 'user_idが存在していなければ無効' do
  		genre.user_id = ''
  		expect(genre).to_not be_valid
  	end

  	it 'nameが存在していなければ無効' do
  		genre.name = ''
  		expect(genre).to_not be_valid
  	end

  	it 'nameは20文字以下であること' do
  		genre.name = 'a' * 21
  		expect(genre).to_not be_valid
  	end
  end
end
