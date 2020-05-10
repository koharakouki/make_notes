class Article < ApplicationRecord

	belongs_to :user
	has_many :favorites, dependent: :destroy
	validates :article_title, presence: true, length: { maximum: 35 }
	validates :content, presence: true

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	def self.search(content)
      if content
         where(['article_title or content LIKE ?', "%#{content}%"])
      end
   end
end
