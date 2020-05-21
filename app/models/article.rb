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
  def create_notification_by(current_user)
  	notification = current_user.active_notifications.new(aritcle_id: id,
  	                                                     visited_id: user_id,
  	                                                     action: "favorite")
  	notification.save if notification.valid?
  end

# コメントに対する通知
  def create_notification_comment!(current_user, article_comment_id)
  	temp_ids = Comment.select(:user_id).where(article_id: id).where_not(user_id: current_user.id).distinct
  	temp_ids.each do |temp_id|
  		save_notification_comment!(current_user, article_comment_id, temp_id['user_id'])
  	end
  	if temp_ids.blank?
  		save_notification_comment!(current_user, article_comment_id, user_id)
  	end
  end

  def save_notification_comment!(current_user, article_comment_id, visited_id)
  	notification = current_user.active_notifications.new(aritcle_id: id,
  	                                                     article_comment_id: article_comment_id,
  	                                                     visited_id: visited_id,
  	                                                     action: 'comment')
  	# 自分の投稿に対するコメントは通知済み
  	if notification.visiter_id == notification.visited_id
  		notification.checked = true
  	end

  	notification.save if notification.valid?
  end

end
