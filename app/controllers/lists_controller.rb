class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:create, :update, :destroy]

  def want
    @user = User.find_by(id: params[:user_id])
    @list = List.new
    @genres = current_user.genres
    if params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
    end

    # 並び替え機能の処理（並び替えボタンを押すとパラメータにsortが入る)
    if params[:sort].present?
      if @genre.present?
        case params[:sort]
        when nil || "1" # 追加順or選択されてない
          @want_list = @user.lists.order_addition(false, @genre, params)
        when "2" # 日時降順
          @want_list = @user.lists.order_desc_or_asc(false, @genre, :desc, params)
        when "3" # 日時昇順
          @want_list = @user.lists.order_desc_or_asc(false, @genre, :asc, params)
        end

      else # ジャンルがALLの場合
        case params[:sort]
        when nil || "1" # 追加順or選択されてない
          @want_list = @user.lists.all_order_addition(false, params)
        when "2" # 日時降順
          @want_list = @user.lists.all_order_desc_or_asc(false, :desc, params)
        when "3" # 日時昇順
          @want_list = @user.lists.all_order_desc_or_asc(false, :asc, params)
        end
      end
    else #並び替えではなく、リンクをクリックして一覧画面へ遷移してきた場合
      if @genre.present?
        @want_list = @user.lists.list_index(false, @genre, params)
      else
        @want_list = @user.lists.all_list_index(false, params)
      end
    end
  end

  def done
    @user = User.find_by(id: params[:user_id])
    @list = List.new
    @genres = current_user.genres
    if params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
    end

    # 並び替え機能の処理（並び替えボタンを押すとパラメータにsortが入る)
    if params[:sort].present?
      if @genre.present?
        case params[:sort]
        when nil || "1" # 追加順or選択されてない
          @done_list = @user.lists.includes(:genre).where(is_watched: true).where(genre_id: @genre.id).
            order(updated_at: :desc).page(params[:page]).per(15)
        when "2" # 日時降順
          @done_list = @user.lists.includes(:genre).where(is_watched: true).where(genre_id: @genre.id).
            order(start_time: :desc).page(params[:page]).per(15)
        when "3" # 日時昇順
          @done_list = @user.lists.includes(:genre).where(is_watched: true).where(genre_id: @genre.id).
            order(start_time: :asc).page(params[:page]).per(15)
        end

      else # ジャンルがALLの場合
        case params[:sort]
        when nil || "1" # 追加順or選択されてない
          @done_list = @user.lists.includes(:genre).where(is_watched: true).
            order(updated_at: :desc).page(params[:page]).per(15)
        when "2" # 日時降順
          @done_list = @user.lists.includes(:genre).where(is_watched: true).
            order(start_time: :desc).page(params[:page]).per(15)
        when "3" # 日時昇順
          @done_list = @user.lists.includes(:genre).where(is_watched: true).
            order(start_time: :asc).page(params[:page]).per(15)
        end
      end
    else #並び替えではなく、リンクをクリックして一覧画面へ遷移してきた場合
      if @genre.present?
        @done_list = @user.lists.includes(:genre).where(is_watched: true).where(genre_id: @genre.id).
          order(updated_at: :desc).page(params[:page]).per(15)
      else
        @done_list = @user.lists.includes(:genre).where(is_watched: true).
          order(updated_at: :desc).page(params[:page]).per(15)
      end
    end
  end

  def create
    @list = List.new(list_params)
    @list.user_id = current_user.id

    if params[:add_want].present? #観たいに追加の場合、パラメータにadd_wantが入る
      respond_to do |format|
        if @list.save
          format.html { redirect_to request.referer }
          format.js { render 'want_success' }
        else
          format.html { redirect_to request.referer }
          format.js { render 'want_error' }
        end
      end
    elsif params[:add_done].present? #観たに追加の場合、パラメータにadd_doneが入る
      respond_to do |format|
        if @list.save
          format.html { redirect_to request.referer }
          format.js { render 'done_success' }
        else
          format.html { redirect_to request.referer }
          format.js { render 'done_error' }
        end
      end
    end
  end

  def show
    @user = User.find_by(id: params[:user_id])
    @list = List.find(params[:id])
    @articles = Article.all.order(created_at: :desc)
  end

  def update
    @list = List.find(params[:list_id])
    @articles = Article.all.order(created_at: :desc)

    if params[:edit_list].present? #タイトルをクリックして編集する場合、パラメータにedit_listが入る
      respond_to do |format|
        if @list.update(list_params)
          format.html { redirect_to request.referer }
          format.js { render 'edit_success' }
        else
          format.html { redirect_to request.referer }
          format.js { render 'edit_error' }
        end
      end
    elsif params[:update_want].present? #観たへ追加をクリックして編集する場合、パラメータにupdate_wantが入る
      respond_to do |format|
        if @list.update(list_params)
          if params[:genre_id].present?
            @genre = Genre.find(params[:genre_id])
          end
          if @genre.present?
            @want_list = current_user.lists.where(is_watched: false).where(genre_id: @genre.id).
              order(created_at: :desc).page(params[:page]).per(15)
          else
            @want_list = current_user.lists.where(is_watched: false).
              order(created_at: :desc).page(params[:page]).per(15)
          end
          format.html { redirect_to user_lists_path(current_user.id) }
          format.js { render 'update_want_success' }
        else
          format.html { redirect_to request.referer }
          format.js { render 'update_want_error' }
        end
      end
    else #showページからの編集の場合
      if @list.update(list_params)
        redirect_to user_list_url(user_id: @list.user.id, id: @list.id)
      else
        render 'show'
      end
    end
  end

  def destroy
    @list = List.find(params[:id])

    # リストの削除を非同期で行なっているので、レンダリング先をdoneとwantで場合分けする
    if @list.is_watched == true
      respond_to do |format|
        if @list.delete
          if params[:genre_id].present?
            @genre = Genre.find(params[:genre_id])
          end
          if @genre.present?
            @done_list = @user.lists.where(is_watched: true).where(genre_id: @genre.id).
              order(updated_at: :desc).page(params[:page]).per(15)
          else
            @done_list = @user.lists.where(is_watched: true).
              order(updated_at: :desc).page(params[:page]).per(15)
           end
          format.html { redirect_to done_path(current_user, { genre_id: @list.genre.id }) }
          format.js { render 'done' }
        end
      end
    elsif @list.is_watched == false
      respond_to do |format|
        if @list.delete
          if params[:genre_id].present?
            @genre = Genre.find(params[:genre_id])
          end
          if @genre.present?
            @want_list = current_user.lists.where(is_watched: false).where(genre_id: @genre.id).
              order(created_at: :desc).page(params[:page]).per(15)
          else
            @want_list = current_user.lists.where(is_watched: false).
              order(created_at: :desc).page(params[:page]).per(15)
           end
          format.js { render 'want' }
        end
      end
    end
  end

  private #---------------------------------------------------------------------------------

  def list_params
    params.require(:list).permit(:title, :genre_id, :media, :start_time,
                                 :rate, :impression, :is_watched)
  end

  def correct_user
    @user = User.find_by(id: params[:user_id])
    if @user != current_user
      redirect_to root_path
    end
  end
end
