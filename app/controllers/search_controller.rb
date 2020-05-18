class SearchController < ApplicationController
  before_action :authenticate_user!

	def search
	 	if params[:model] == "user"
	 	  @users = User.page(params[:page]).per(10).search(params[:search])
	 	  @rank_users = User.find(Relationship.group(:followed_id).order(Arel.sql('count(followed_id) DESC')).pluck(:followed_id))
		 	render 'search_user'
		elsif params[:model] == "article"
			@articles = Article.order(created_at: :desc).page(params[:page]).per(8).search(params[:search])
			render 'search_article'
		end
	end

end
