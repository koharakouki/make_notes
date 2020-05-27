class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:create]

  def index
    @user = User.find_by(id: params[:user_id])
    @genres = @user.genres.page(params[:page]).per(6)
    @genre = current_user.genres.build

    # 新着記事を表示するためインスタンス変数に渡す
    @articles = Article.all.order(created_at: :desc)
  end

  def create
    @genre = current_user.genres.build(genre_params)
    if @genre.save
      @user = User.find_by(id: params[:user_id])
      @genres = @user.genres.page(params[:page]).per(6)
      respond_to do |format|
        format.html { redirect_to user_genres_path(user_id: @user.id) }
        format.js
      end
    else
      @genres = @user.genres.page(params[:page]).per(6)
      @articles = Article.all.order(created_at: :desc)
      render 'index'
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy
    redirect_to user_genres_path(current_user)
  end

  private #------------------------------------------------------------------

  def genre_params
    params.require(:genre).permit(:name)
  end

  def correct_user
    @user = User.find_by(id: params[:user_id])
    if @user != current_user
      redirect_to root_path
    end
  end
end
