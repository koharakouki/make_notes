require 'rails_helper'

RSpec.describe ArticleComment, type: :model do
  describe 'バリデーションのテスト' do
    let!(:user) { create(:user) }
    let!(:article) { create(:article, user_id: user.id) }
    let!(:article_comment) { create(:article_comment, user_id: user.id, article_id: article.id) }

    it '項目が存在すれば有効' do
      expect(article_comment).to be_valid
    end

    it 'user_idが存在していなければ無効' do
      article_comment.user_id = ''
      expect(article_comment).not_to be_valid
    end

    it 'article_idが存在していなければ無効' do
      article_comment.article_id = ''
      expect(article_comment).not_to be_valid
    end

    it 'contentが存在していなければ無効' do
      article_comment.content = ''
      expect(article_comment).not_to be_valid
    end

    it 'contentが100文字以下であること' do
      article_comment.content = "a" * 101
      expect(article_comment).not_to be_valid
    end
  end
end
