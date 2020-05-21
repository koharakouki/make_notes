class FavoritesController < ApplicationController
  before_action :authenticate_user!

	def create
		@article = Article.find(params[:article_id])
		favorite = current_user.favorites.build(article_id: @article.id)
		favorite.save
		# 通知の作成
		@article.create_notification_by(current_user)
	end

	def destroy
    @article = Article.find(params[:article_id])
    favorite = current_user.favorites.find_by(article_id: @article.id)
    favorite.destroy
	end

end
