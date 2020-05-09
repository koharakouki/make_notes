class Genre < ApplicationRecord
	belongs_to :user
	has_many :lists

	# もっと見るで表示させる数
	paginates_per 6
end
