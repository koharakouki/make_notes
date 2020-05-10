class ArticlesController < ApplicationController

	def new
		@article = Article.new
	end

	def create
		@article =Article.new(article_params)
		@article.user_id = current_user.id
		if @article.save
			redirect_to articles_path
		else
			render 'new'
		end
	end

	def index
		# いいねした記事のみを表示する（複雑になってしまったので他の方法考える）
		# いいねした記事のみを表示リンクのパラメータに[:favorite]を持たせる
		if params[:favorite].present?
			articles = []
			Article.all.each do |article|
				article.favorites.each do |favorite|
					if favorite.user_id == current_user.id
						articles << favorite.article
					end
				end
			end
			配列に対してのページネーションなので記述の仕方が違う
			@articles = Kaminari.paginate_array(articles).page(params[:page]).per(8)
		else
			@articles = Article.order(created_at: :desc).page(params[:page]).per(8)
		end
	end

	def show
		@article = Article.find(params[:id])
		@article_comment = ArticleComment.new
		@article_comments = ArticleComment.where(article_id: @article.id).page(params[:page]).per(10)
	end

	private

	def article_params
		params.require(:article).permit(:article_title, :content, :is_spoiler)
	end
end
