class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    if @article.save
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def index
    # いいねした記事のみを表示するためにリンクのパラメータに[:favorite]を持たせる
    if params[:favorite].present?
      articles = Article.joins(:favorites).where(user_id: current_user.id)

      # 配列に対してのページネーションなので記述の仕方が違う
      @articles = Kaminari.paginate_array(articles).page(params[:page]).per(8)
    else
      @articles = Article.order(created_at: :desc).page(params[:page]).per(8)
    end
  end

  def show
    @article = Article.find(params[:id])
    @article_comment = ArticleComment.new
    @article_comments = ArticleComment.includes(:user).where(article_id: @article.id).
      order(created_at: :desc).page(params[:page]).per(10)
  end

  def destroy
    @article = Article.find(params[:id])
    @article.delete
    redirect_back(fallback_location: root_path)
  end

  private #-------------------------------------------------------------------------

  def article_params
    params.require(:article).permit(:article_title, :content, :is_spoiler)
  end
end
