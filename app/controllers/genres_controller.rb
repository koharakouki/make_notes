class GenresController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :correct_user, only: [:create]

  def index
  	@user = User.find_by(id: params[:user_id])
  	@genres = @user.genres.page(params[:page]).per(8)
  	@genre = current_user.genres.build
    # おすすめ記事の場合
    # @rank_article = Article.find(Favorite.group(:article_id).order('count(article_id) desc').pluck(:article_id))

    # 新着記事の場合
    @articles = Article.all.order(created_at: :desc)
  end

  def create
  	@genre = current_user.genres.build(genre_params)
  	if @genre.save
      @user = User.find_by(id: params[:user_id])
      @genres = @user.genres.page(params[:page]).per(8)
      respond_to do |format|
        format.html { redirect_to request.referer }
        format.js
      end
    else
      render 'error'
  	end
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
