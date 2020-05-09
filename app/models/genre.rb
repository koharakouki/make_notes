class Genre < ApplicationRecord
	belongs_to :user
	has_many :lists
	validates :name, presence: true, length: { maximum: 8 }

	# もっと見るで表示させる数
	paginates_per 6
end
