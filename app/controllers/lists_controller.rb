class ListsController < ApplicationController

	def index
		@user = User.find_by(id: params[:user_id])
		@list = List.new
		@genre = Genre.find(params[:genre_id])
		@genres = current_user.genres
		@want_list = @user.lists.where(is_watched: false)
		@done_list = @user.lists.where(is_watched: true)
	end

	def create
		@list = List.new(list_params)
		@list.user_id = current_user.id
		if @list.save!
			redirect_back(fallback_location: user_genres_path)
		end
	end

	def update
		@list = List.find(params[:list_id])
		@list.is_watched = true
		if @list.update(list_params)
			redirect_back(fallback_location: user_genres_path)
		end
	end

	private

	def list_params
		params.require(:list).permit(:title, :genre_id, :media, :start_time, :rate, :impression)
	end
end
