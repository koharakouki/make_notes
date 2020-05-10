class SearchController < ApplicationController

	 def search
	 	if params[:model] == "user"
	 	   @users = User.page(params[:page]).per(10).search(params[:search])
		 	render 'search_user'
		elsif params[:model] == "article"
			# @articles = Article.page(params[:page]).per(10).search(params[:search])
			@articles = Article.order(created_at: :desc).page(params[:page]).per(8).search(params[:search])
			# @articles = Article.page(params[:page]).per(8).search(params[:search])
			render 'search_article'
		end
	 end
end
