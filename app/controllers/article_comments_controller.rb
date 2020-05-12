class ArticleCommentsController < ApplicationController

	def create
		article = Article.find(params[:article_id])
		article_comment = current_user.article_comments.build(article_comment_params)
		article_comment.article_id = article.id
		if article_comment.save
			# create.js.erbに渡すためにインスタンス変数にそれぞれ代入する
			@article = Article.find(params[:article_id])
			@article_comment = ArticleComment.new
			@article_comments = ArticleComment.where(article_id: @article.id).order(created_at: :desc).page(params[:page]).per(10)
			respond_to do |format|
	          format.html { redirect_to request.referer }
	          format.js
		  end
		else
			# flash[:notice] = 'コメントを追加できませんでした'
			redirect_to request.referer
		end
	end

	def destroy
		article_comment = ArticleComment.find(params[:id])
		if article_comment.user == current_user || current_admin
			article_comment.destroy
			# destroy.js.erbに渡すためにインスタンス変数にそれぞれ代入する
			@article = Article.find(params[:article_id])
			@article_comment = ArticleComment.new
			@article_comments = ArticleComment.where(article_id: @article.id).order(created_at: :desc).page(params[:page]).per(10)
			respond_to do |format|
	        format.html { redirect_to request.referer }
	        format.js
		  end
		end
	end

	private #----------------------------------------------------------------------

	def article_comment_params
		params.require(:article_comment).permit(:content)
	end
end
