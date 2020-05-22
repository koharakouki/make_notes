class Article < ApplicationRecord
  belongs_to :user
  has_many :article_comment, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  validates :article_title, presence: true, length: { maximum: 35 }
  validates :content, presence: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search(content)
    if content
      where('article_title LIKE ? OR content LIKE ?', "%#{content}%", "%#{content}%")
    end
  end

  # いいねに対する通知
  def create_notification_favorite!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(
      [
        "visiter_id = ? and visited_id = ? and article_id = ? and action = ? ",
        current_user.id, user_id, id, 'favorite',
      ]
    )
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        article_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visiter_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # コメントに対する通知
  def create_notification_comment!(current_user, article_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知
    temp_ids = ArticleComment.select(:user_id).where(article_id: id).
      where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, article_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知
    save_notification_comment!(current_user, article_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, article_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知
    notification = current_user.active_notifications.new(
      article_id: id,
      article_comment_id: article_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
