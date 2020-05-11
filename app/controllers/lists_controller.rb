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
		if params[:add_want].present?
			respond_to do |format|
				if @list.save
	            format.html { redirect_to request.referer }
	            format.js { render 'want_success'}
	         else
	         	format.html { redirect_to request.referer }
				   format.js { render 'want_error'}
			   end
			end
		elsif params[:add_done].present?
			respond_to do |format|
				if @list.save
	            format.html { redirect_to request.referer }
	            format.js { render 'done_success'}
	         else
	         	format.html { redirect_to request.referer }
				   format.js { render 'done_error'}
			   end
			end
		end
	end

	def show
		@user = User.find_by(id: params[:user_id])
		@list = List.find(params[:id])
		@articles = Article.all.order(created_at: :desc)
	end

	def update
		@list = List.find(params[:list_id])
		respond_to do |format|
			if @list.update(list_params)
			　　format.html { redirect_to request.referer }
            format.js { render 'success'}
         else
         	format.html { redirect_to request.referer }
            format.js { render 'error'}
         end
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
