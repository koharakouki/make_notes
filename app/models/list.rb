class List < ApplicationRecord
	belongs_to :user
	belongs_to :genre

  validates :media, length: { maximum: 20 }
	validates :title, presence: true, length: { maximum: 23 }
	validates :genre_id, presence: true
	validates :user_id, presence: true

end
