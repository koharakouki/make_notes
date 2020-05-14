class ListsController < ApplicationController
	before_action :correct_user, only: [:create, :update, :destroy]

	# def index
	# 	@user = User.find_by(id: params[:user_id])
	# 	@list = List.new
	# 	@genres = current_user.genres
	# 	if params[:genre_id].present?
	# 		@genre = Genre.find(params[:genre_id])
	# 	end
	# 	if @genre.present?
	# 		@want_list = @user.lists.where(is_watched: false).where(genre_id: @genre.id).page(params[:page]).per(15)
	# 		@done_list = @user.lists.where(is_watched: true).where(genre_id: @genre.id).page(params[:page]).per(15)
	# 	else
	# 		@want_list = @user.lists.where(is_watched: false).page(params[:page]).per(15)
	# 		@done_list = @user.lists.where(is_watched: true).page(params[:page]).per(15)
	# 	end
	# end

	def want
		@user = User.find_by(id: params[:user_id])
		@list = List.new
		@genres = current_user.genres
		if params[:genre_id].present?
			@genre = Genre.find(params[:genre_id])
		end
		# if @genre.present?
		# 	@want_list = @user.lists.where(is_watched: false).where(genre_id: @genre.id).order(created_at: :desc).page(params[:page]).per(15)
		# else
		# 	@want_list = @user.lists.where(is_watched: false).order(created_at: :desc).page(params[:page]).per(15)
		# end

		# 並び替え機能の処理
		if params[:sort].present?
			if @genre.present?
				case params[:sort]
				when nil || "1"
					@want_list = @user.lists.where(is_watched: false).where(genre_id: @genre.id).order(updated_at: :desc).page(params[:page]).per(15)
				when "2"
					@want_list = @user.lists.where(is_watched: false).where(genre_id: @genre.id).order(start_time: :desc).page(params[:page]).per(15)
				when "3"
					@want_list = @user.lists.where(is_watched: false).where(genre_id: @genre.id).order(start_time: :asc).page(params[:page]).per(15)
				end
			else
				case params[:sort]
				when nil || "1"
					@want_list = @user.lists.where(is_watched: false).order(updated_at: :desc).page(params[:page]).per(15)
				when "2"
					@want_list = @user.lists.where(is_watched: false).order(start_time: :desc).page(params[:page]).per(15)
				when "3"
					@want_list = @user.lists.where(is_watched: false).order(start_time: :asc).page(params[:page]).per(15)
				end
			end
		else
			if @genre.present?
			  @want_list = @user.lists.where(is_watched: false).where(genre_id: @genre.id).order(updated_at: :desc).page(params[:page]).per(15)
		  else
			  @want_list = @user.lists.where(is_watched: false).order(updated_at: :desc).page(params[:page]).per(15)
		  end
		end
	end

	def done
		@user = User.find_by(id: params[:user_id])
		@list = List.new
		@genres = current_user.genres
		if params[:genre_id].present?
			@genre = Genre.find(params[:genre_id])
		end

		# 並び替え機能の処理
		if params[:sort].present?
			if @genre.present?
				case params[:sort]
				when nil || "1"
					@done_list = @user.lists.where(is_watched: true).where(genre_id: @genre.id).order(updated_at: :desc).page(params[:page]).per(15)
				when "2"
					@done_list = @user.lists.where(is_watched: true).where(genre_id: @genre.id).order(start_time: :desc).page(params[:page]).per(15)
				when "3"
					@done_list = @user.lists.where(is_watched: true).where(genre_id: @genre.id).order(start_time: :asc).page(params[:page]).per(15)
				end
			else
				case params[:sort]
				when nil || "1"
					@done_list = @user.lists.where(is_watched: true).order(updated_at: :desc).page(params[:page]).per(15)
				when "2"
					@done_list = @user.lists.where(is_watched: true).order(start_time: :desc).page(params[:page]).per(15)
				when "3"
					@done_list = @user.lists.where(is_watched: true).order(start_time: :asc).page(params[:page]).per(15)
				end
			end
		else
			if @genre.present?
			  @done_list = @user.lists.where(is_watched: true).where(genre_id: @genre.id).order(updated_at: :desc).page(params[:page]).per(15)
		  else
			  @done_list = @user.lists.where(is_watched: true).order(updated_at: :desc).page(params[:page]).per(15)
		  end
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
		if params[:edit_list].present?
			respond_to do |format|
				if @list.update(list_params)
					format.html { redirect_to request.referer }
	        format.js { render 'edit_success'}
	      else
	        format.html { redirect_to request.referer }
	        format.js { render 'edit_error'}
	      end
			end
		elsif params[:update_want].present?
			respond_to do |format|
				if @list.update(list_params)
					if params[:genre_id].present?
						@genre = Genre.find(params[:genre_id])
					end
					if @genre.present?
						@want_list = current_user.lists.where(is_watched: false).where(genre_id: @genre.id).order(created_at: :desc).page(params[:page]).per(15)
					else
						@want_list = current_user.lists.where(is_watched: false).order(created_at: :desc).page(params[:page]).per(15)
					end
					format.html { redirect_to user_lists_path(current_user.id) }
	        format.js { render 'update_want_success'}
	      else
	        format.html { redirect_to request.referer }
	        format.js { render 'update_want_error'}
	      end
			end
		else
			@list.update!(list_params)
			redirect_to request.referer
		end
	end

	def destroy
		@list = List.find(params[:id])
		if @list.is_watched == true
			respond_to do |format|
	      if @list.delete
		      if params[:genre_id].present?
					  @genre = Genre.find(params[:genre_id])
				  end
					if @genre.present?
					  @done_list = @user.lists.where(is_watched: true).where(genre_id: @genre.id).order(updated_at: :desc).page(params[:page]).per(15)
				  else
					  @done_list = @user.lists.where(is_watched: true).order(updated_at: :desc).page(params[:page]).per(15)
				  end
					format.html { redirect_to done_path(current_user, { genre_id: @list.genre.id }) }
			    format.js { render 'done' }
		    end
			end
		elsif @list.is_watched == false
			respond_to do |format|
	      if @list.delete
	      	if params[:genre_id].present?
					  @genre = Genre.find(params[:genre_id])
				  end
					if @genre.present?
						@want_list = current_user.lists.where(is_watched: false).where(genre_id: @genre.id).order(created_at: :desc).page(params[:page]).per(15)
					else
						@want_list = current_user.lists.where(is_watched: false).order(created_at: :desc).page(params[:page]).per(15)
					end
		      format.js { render 'want' }
		    end
			end
		end
	end

	private #-----------------------------------------------------------------------------------------------

	def list_params
		params.require(:list).permit(:title, :genre_id, :media, :start_time, :rate, :impression, :is_watched)
	end

	def correct_user
		@user = User.find_by(id: params[:user_id])
		if @user != current_user
			redirect_to root_path
		end
	end
end
