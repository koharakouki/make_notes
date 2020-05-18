class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

 	def index
 		@users = User.page(params[:page]).per(10)
 		#フォロワーランキング
		@rank_users = User.find(Relationship.group(:followed_id).order(Arel.sql('count(followed_id) DESC')).pluck(:followed_id))
 	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect_to user_genres_path(current_user)
		else
			render 'edit'
		end
	end

	# def destroy
	# 	@user = User.find(params[:id])
	# 	@user.delete
	# 	redirect_back(fallback_location: admin_users_path)
	# end

	def following
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(10)
    @rank_users = User.find(Relationship.group(:followed_id).order(Arel.sql('count(followed_id) DESC')).pluck(:followed_id))
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(10)
    @rank_users = User.find(Relationship.group(:followed_id).order(Arel.sql('count(followed_id) DESC')).pluck(:followed_id))
    render 'show_follow'
  end

	def calendar
		@user = User.find(params[:id])
		@watched_lists = @user.lists.where(is_watched: true)

		# チャートを表示するための処理
		genres = @user.genres
		hash = {}
		genres.each do |genre|
			value = genre.lists.where(user_id: @user.id).where(genre_id: genre.id).where(is_watched: true).count
			hash.merge!(genre.name => value)
		end
		@chart = hash
	end


	private #----------------------------------------------------------------------

	def user_params
		params.require(:user).permit(:name, :image, :introduction)
	end

	def correct_user
		@user = User.find(params[:id])
		if @user != current_user
			redirect_to root_path
		end
	end

end
