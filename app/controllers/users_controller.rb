class UsersController < ApplicationController

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
	end

	private

	def user_params
		params.require(:user).permit(:name, :image, :introduction)
	end
end
