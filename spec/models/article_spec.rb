require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'バリデーションのテスト' do
    let!(:article) { create(:article) }

    it '項目が存在すれば有効' do
      expect(article).to be_valid
    end

    it 'user_idが存在していなければ無効' do
      article.user_id = ''
      expect(article).not_to be_valid
    end

    it 'article_titleが存在していなければ無効' do
      article.article_title = ''
      expect(article).not_to be_valid
    end

    it 'article_titleが35文字以下であること' do
      article.article_title = 'a' * 36
      expect(article).not_to be_valid
    end

    it 'contentが存在していなければ無効' do
      article.content = ''
      expect(article).not_to be_valid
    end
  end
end
