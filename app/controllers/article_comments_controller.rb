class ArticleCommentsController < ApplicationController

	def create
		@article = Article.find(params[:article_id])
		@article_comment = current_user.article_comments.build(article_comment_params)
		@article_comment.article_id = @article.id
		if @article_comment.save
			redirect_to request.referer
		end
	end

	def destroy
		@article = Article.find(params[:article_id])
		@article_comment = ArticleComment.find(params[:id]).destroy
		redirect_to request.referer
	end

	private

	def article_comment_params
		params.require(:article_comment).permit(:content)
	end
end
