class ArticlesController < ApplicationController

	def new
		@article = Article.new
	end

	def create
		@article =Article.new(article_params)
		@article.user_id = current_user.id
		if @article.save
			redirect_to articles_path
		end
	end

	def index
		@articles = Article.page(params[:page]).per(10)
	end

	def show
		@article = Article.find(params[:id])
	end

	private

	def article_params
		params.require(:article).permit(:article_title, :content, :is_spoiler)
	end
end
