require 'rails_helper'

RSpec.describe "ArticleCommentsController", type: :request do
	let!(:user) { create(:user) }
	let!(:article) { create(:article, user_id: user.id) }
	before do
		sign_in user
	end

	describe 'POST #create' do
		context '正常なパラメータの場合' do
			let(:article_comment) { build(:article_comment) }

			it 'リクエストが成功すること' do
				post article_article_comments_url(article.id),
				params: { article_comment: FactoryBot.attributes_for(:article_comment) },
				xhr: true
				expect(response.status).to eq 200
			end

			it 'コメントが投稿されること' do
				expect do
					post article_article_comments_url(article.id),
					params: { article_comment: FactoryBot.attributes_for(:article_comment) },
					xhr: true
				end.to change { ArticleComment.all.count }.by(1)
			end

			it '投稿したコメントが表示されること' do
				post article_article_comments_url(article.id),
				params: { article_comment: FactoryBot.attributes_for(:article_comment) },
				xhr: true
				expect(response.body).to include "#{article_comment.content}"
			end

			it '通知されること' do
				expect do
					post article_article_comments_url(article.id),
					params: { article_comment: FactoryBot.attributes_for(:article_comment) },
					xhr: true
				end.to change { Notification.all.count }.by(1)
			end
		end

    context '不正なパラメータの場合' do
      it 'リクエストが成功すること' do
        post article_article_comments_url(article.id),
        params: { article_comment: FactoryBot.attributes_for(:article_comment, content: nil) },
        xhr: true
        expect(response.status).to eq 200
      end

      it 'コメントが投稿されないこと' do
      	expect do
	        post article_article_comments_url(article.id),
	        params: { article_comment: FactoryBot.attributes_for(:article_comment, content: nil) },
	        xhr: true
        end.to_not change { ArticleComment.all.count }
      end
    end
	end


	describe 'DELETE #destroy' do
		let!(:article_comment) { create(:article_comment, user_id: user.id, article_id: article.id) }
		it 'リクエストに成功すること' do
			delete article_article_comments_url(article_id: article.id, id: article_comment.id), xhr: true
			expect(response.status).to eq 200
		end

		it '投稿が削除されること' do
			expect do
			  delete article_article_comments_url(article_id: article.id, id: article_comment.id), xhr: true
			end.to change { ArticleComment.all.count }.by(-1)
		end
	end
end
