class ArticleComment < ApplicationRecord
	belongs_to :user
	belongs_to :article

	validates :content, presence: true, length: { maximum: 100 }
end
