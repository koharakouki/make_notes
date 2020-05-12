class Genre < ApplicationRecord
	belongs_to :user
	has_many :lists
	validates :name, presence: true, length: { maximum: 20 }

end
