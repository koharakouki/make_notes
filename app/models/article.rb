class Article < ApplicationRecord

	belongs_to :user
	has_many :favorites, dependent: :destroy

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	def self.search(content)
      if content
         where(['article_title or content LIKE ?', "%#{content}%"])
      end
   end
end
