class ListsController < ApplicationController
  include Common
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
        genre_exist_sort(@user.lists, false, @genre)
        @want_list = @want_list_or_done_list

      else # ジャンルがALLの場合
        all_genre_sort(@user.lists, false)
        @want_list = @want_list_or_done_list
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
        genre_exist_sort(@user.lists, true, @genre)
        @done_list = @want_list_or_done_list

      else # ジャンルがALLの場合
        all_genre_sort(@user.lists, true)
        @done_list = @want_list_or_done_list
      end

    else #並び替えではなく、リンクをクリックして一覧画面へ遷移してきた場合
      if @genre.present?
        @done_list = @user.lists.list_index(true, @genre, params)
      else
        @done_list = @user.lists.all_list_index(true, params)
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
            @want_list = current_user.lists.watched_update_add_index(false, @genre, params)
          else
            @want_list = current_user.lists.all_watched_update_add_index(false, params)
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
            @done_list = @user.lists.watched_update_add_index(true, @genre, params)
          else
            @done_list = @user.lists.all_watched_update_add_index(true, params)
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
            @want_list = current_user.lists.watched_update_add_index(false, @genre, params)
          else
            @want_list = current_user.lists.all_watched_update_add_index(false, params)
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
