class SearchController < ApplicationController

	 def search
	 	@users = User.page(params[:page]).per(10).search(params[:search])
	 	render 'search_user'
	 end
end
