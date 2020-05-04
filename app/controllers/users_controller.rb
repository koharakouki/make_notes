class UsersController < ApplicationController

	def edit
		@user = User.find_by(name: params[:name])
	end

	def update
		@user = User.find_by(name: params[:name])
		if @user.update(user_params)
			redirect edit_user_path
		else
			render 'edit'
		end
	end

	private

	def user_params
		params.require(:user).permit(:name, :image)
	end
end
