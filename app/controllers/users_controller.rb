class UsersController < ApplicationController

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

	def show_follow
		@user = User.find(params[:id])
		@following = @user.following.all
		@followers = @user.followers.all
		@rank_users = User.find(Relationship.group(:followed_id).order('count(followed_id) DESC').pluck(:followed_id))
	end

	def calendar
		@user = User.find(params[:id])
		@watched_lists = @user.lists.where(is_watched: true)
	end

	private

	def user_params
		params.require(:user).permit(:name, :image, :introduction)
	end
end
