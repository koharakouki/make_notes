class Admin::UsersController < ApplicationController
	before_action :authenticate_admin!

	def index
		# @users = User.page(params[:page]).per(20)
		@q = User.ransack(params[:q])
      @users = @q.result
	end

	def chart
	end
end
