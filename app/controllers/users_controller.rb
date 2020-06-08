class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.user_desc(params)
    # フォロワーランキング
    @rank_users = User.ranking
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

  def following
    @user  = User.find(params[:id])
    @users = @user.following.user_desc(params)
    @rank_users = User.ranking
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers.user_desc(params)
    @rank_users = User.ranking
    render 'show_follow'
  end

  def calendar
    @user = User.find(params[:id])
    @watched_lists = @user.lists.where(is_watched: true)

    # チャートを表示するための処理
    genres = @user.genres
    @chart = {}
    genres.each do |genre|
      # value = genre.lists.where(user_id: @user.id).
      #   where(genre_id: genre.id).where(is_watched: true).count
      value = genre.lists.where("user_id = ? AND genre_id = ? AND is_watched = ?", @user.id, genre.id, true).count
      @chart.merge!(genre.name => value)
    end
    # @chart = hash
  end


  private #----------------------------------------------------------------------

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end

  def correct_user
    # @user = User.find(params[:id])
    if User.find(params[:id]) != current_user
      redirect_to root_path
    end
  end
end
