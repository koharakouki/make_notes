class List < ApplicationRecord
  belongs_to :user
  belongs_to :genre

  validates :media, length: { maximum: 20 }
  validates :title, presence: true, length: { maximum: 23 }
  validates :user_id, presence: true


  # ジャンルが存在し選択されていないor追加順で並び替えの場合
  scope :order_addition, ->(truth, genre, params) { includes(:genre).where(is_watched: truth).
                                                    where(genre_id: genre.id).order(updated_at: :desc).
                                                    page(params[:page]).per(15) }


  # ジャンルが存在し降順or昇順で並び替えの場合
  scope :order_desc_or_asc, ->(truth, genre, line, params) { includes(:genre).where(is_watched: truth).
  	                                                         where(genre_id: genre.id).order(start_time: line).
  	                                                         page(params[:page]).per(15) }


  # ジャンルがALLで選択されていないor追加順で並び替えの場合
  scope :all_order_addition, ->(truth, params) { includes(:genre).where(is_watched: truth).
                                                 order(updated_at: :desc).page(params[:page]).per(15) }


  # ジャンルがALLで降順or昇順で並び替えの場合
  scope :all_order_desc_or_asc, ->(truth, line, params) { includes(:genre).where(is_watched: truth).
                                                          order(start_time: line).page(params[:page]).per(15) }

  # 並び替えではなく、リンクをクリックして一覧画面へ遷移してきた場合
  # ジャンル有
  scope :list_index, ->(truth, genre, params) { includes(:genre).where(is_watched: truth).where(genre_id: genre.id).
                                                order(updated_at: :desc).page(params[:page]).per(15) }
  # ジャンル無
  scope :all_list_index, ->(truth, params) { includes(:genre).where(is_watched: truth).
                                             order(updated_at: :desc).page(params[:page]).per(15) }


  # 観たに追加ボタンから編集した場合/リスト削除後の一覧表示
  # ジャンル有
  scope :watched_update_add_index, ->(truth, genre, params) { where(is_watched: truth).where(genre_id: genre.id).
                                                              order(updated_at: :desc).page(params[:page]).per(15) }
  # ジャンル無
  scope :all_watched_update_add_index, ->(truth, params) { where(is_watched: truth).order(updated_at: :desc).
  	                                                       page(params[:page]).per(15)}
end
