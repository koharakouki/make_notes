class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

 	def index
 		@users = User.page(params[:page]).per(10)
 		#フォロワーランキング
		@rank_users = User.find(Relationship.group(:followed_id).order('count(followed_id) DESC').pluck(:followed_id))
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

	def destroy
		@user = User.find(params[:id])
		@user.delete
		redirect_back(fallback_location: root_path)
	end

	def show_follow
		@user = User.find(params[:id])
		@following = @user.following.page(params[:page]).per(20)
		@followers = @user.followers.page(params[:page]).per(20)
		@rank_users = User.find(Relationship.group(:followed_id).order('count(followed_id) DESC').pluck(:followed_id))
	end

	def calendar
		@user = User.find(params[:id])
		@watched_lists = @user.lists.where(is_watched: true)
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
