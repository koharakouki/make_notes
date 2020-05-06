class ListsController < ApplicationController

	def index
		@user = User.find_by(id: params[:user_id])
		@list = List.new
		@genres = current_user.genres
		if params[:genre_id].present?
			@genre = Genre.find(params[:genre_id])
		end
		if @genre.present?
			@want_list = @user.lists.where(is_watched: false).where(genre_id: @genre.id)
			@done_list = @user.lists.where(is_watched: true).where(genre_id: @genre.id)
		else
			@want_list = @user.lists.where(is_watched: false)
			@done_list = @user.lists.where(is_watched: true)
		end
	end

	def create
		@list = List.new(list_params)
		@list.user_id = current_user.id
		if @list.save!
			redirect_back(fallback_location: user_genres_path)
		end
	end

	def show
		@user = User.find_by(id: params[:user_id])
		@list = List.find(params[:id])
	end

	def update
		@list = List.find(params[:list_id])
		@list.is_watched = true
		if @list.update(list_params)
			redirect_back(fallback_location: user_genres_path)
		end
	end

	def destroy
		@list = List.find(params[:id])
		if @list.delete
			redirect_to user_genres_path(@list.user.id)
		end
	end

	private

	def list_params
		params.require(:list).permit(:title, :genre_id, :media, :start_time, :rate, :impression, :is_watched)
	end
end
