module Common
	extend ActiveSupport::Concern

  # ジャンルが存在する場合の並び替え
	def genre_exist_sort(lists, true_or_false, genre)
    case params[:sort]
    when nil || "1" # 追加順or選択されてない
      @want_list_or_done_list = lists.order_addition(true_or_false, genre, params)
    when "2" # 日時降順
      @want_list_or_done_list = lists.order_desc_or_asc(true_or_false, genre, :desc, params)
    when "3" # 日時昇順
      @want_list_or_done_list = lists.order_desc_or_asc(true_or_false, genre, :asc, params)
    end
  end

  # ALLの場合の並び替え
  def all_genre_sort(lists, true_or_false)
  	case params[:sort]
    when nil || "1" # 追加順or選択されてない
      @want_list_or_done_list = lists.all_order_addition(true_or_false, params)
    when "2" # 日時降順
      @want_list_or_done_list = lists.all_order_desc_or_asc(true_or_false, :desc, params)
    when "3" # 日時昇順
      @want_list_or_done_list = lists.all_order_desc_or_asc(true_or_false, :asc, params)
    end
  end

end