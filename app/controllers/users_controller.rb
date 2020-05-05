class UsersController < ApplicationController

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect edit_user_path
		else
			render 'edit'
		end
	end

	def following
		@user = User.find(params[:id]) || current_user
		@users = @user.following.all
		render 'follow_user'
	end

	def followers
		@user = User.find(params[:id])
		@users = @user.followers.all
		render 'follower_user'
	end

	private

	def user_params
		params.require(:user).permit(:name, :image)
	end
end
