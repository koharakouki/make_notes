require 'rails_helper'

RSpec.describe List, type: :model do
  describe 'バリデーションのテスト' do
    let!(:user) { create(:user) }
    let!(:genre) { create(:genre, user_id: user.id, name: '映画') }
  	let!(:list) { create(:list, user_id: user.id, genre_id: genre.id) }

  	it '項目が存在すれば有効' do
  		expect(list).to be_valid
  	end

  	it 'user_idが存在していなければ無効' do
  		list.user_id = ''
  		expect(list).to_not be_valid
  	end

  	it 'titleが存在していなければ無効' do
  		list.title = ''
  		expect(list).to_not be_valid
  	end

  	it 'genre_idが存在していなければ無効' do
  		list.genre_id = ''
  		expect(list).to_not be_valid
  	end

  	it 'mediaは20文字以下であること' do
  		list.media = 'a' * 21
  		expect(list).to_not be_valid
  	end

  	it 'titleは23文字以下であること' do
  		list.title = 'a' * 24
  		expect(list).to_not be_valid
  	end
  end
end
