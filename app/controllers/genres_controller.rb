class GenresController < ApplicationController
  def index
  	@user = User.find_by(id: params[:user_id])
  	@genres = @user.genres.page(params[:page]).per(8)
  	@genre = current_user.genres.build
  end

  def create
  	@genre = current_user.genres.build(genre_params)
  	if @genre.save
  		redirect_to user_genres_path
  	end
  end

  private

  def genre_params
  	params.require(:genre).permit(:name)
  end


end
