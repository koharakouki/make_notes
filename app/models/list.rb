class List < ApplicationRecord
	belongs_to :user
	belongs_to :genre

	validates :title, presence: true, length: { maximum: 23 }
	validates :genre_id, presence: true

end
