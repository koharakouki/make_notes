class Admin::UsersController < ApplicationController
	before_action :authenticate_admin!

	def index
		@q = User.with_deleted.ransack(params[:q])
    @users = @q.result.order(created_at: :desc).page(params[:page]).per(20)
	end

	def chart
    @today = Date.today
    @lastmonth_today = @today.prev_day(7)

		# ユーザー登録をグラフに表示する処理
    create_user_array = []

    User.all.each do |d|
      create_user_array << d.created_at.strftime("%Y年%m月%d日").to_s
    end

    # 配列に含まれている重複している値を数える
    @user_create = create_user_array.each_with_object(Hash.new(0)){|v,o| o[v]+=1}

    # 記事投稿数をグラフに表示する処理
    create_article_array = []

    Article.all.each do |d|
      create_article_array << d.created_at.strftime("%Y年%m月%d日").to_s
    end

    @article_create = create_article_array.each_with_object(Hash.new(0)){|v,o| o[v]+=1}
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

end
