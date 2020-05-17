class Admin::ArticlesController < ApplicationController
	before_action :authenticate_admin!

	def index
		@q = Article.ransack(params[:q])
    @articles = @q.result.order(created_at: :desc).page(params[:page]).per(8)
	end

	def show
		@article = Article.find(params[:id])
		@article_comment = ArticleComment.new
		@article_comments = ArticleComment.where(article_id: @article.id).page(params[:page]).per(10)
	end

	def destroy
		@article = Article.find(params[:id])
		@article.delete
		redirect_to admin_articles_url
	end
end
