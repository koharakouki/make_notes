class ArticleComment < ApplicationRecord
	belongs_to :user
	belongs_to :article
	has_many :notifications, dependent: :destroy

  validates :user_id, presence: true
  validates :article_id, presence: true
	validates :content, presence: true, length: { maximum: 100 }
end
