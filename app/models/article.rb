class Article < ApplicationRecord

	belongs_to :user
	has_many :article_comment, dependent: :destroy
	has_many :favorites, dependent: :destroy
	validates :article_title, presence: true, length: { maximum: 35 }
	validates :content, presence: true
	validates :is_spoiler, presence: true

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	def self.search(content)
    if content
      where('article_title LIKE ? OR content LIKE ?', "%#{content}%", "%#{content}%")
    end
  end
end
