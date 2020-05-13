class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 論理削除の設定
  acts_as_paranoid column: :deleted_at

# 　Refileの設定
  attachment :image

  validates :name, presence: true
  validates :introduction, length: { maximum: 100 }, allow_nil: true
  # メールアドレスの正規表現
  VALID_EMAIL_REGIX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
      format: { with: VALID_EMAIL_REGIX }, uniqueness: { case_sensitive: false }

  has_many :genres
  has_many :lists
  has_many :articles
  has_many :favorites, dependent: :destroy
  has_many :article_comments

# フォロー・フォロワーのための関連付け
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships


  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followers?(other_user)
    followers.include?(other_user)
  end

  def self.search(content)
    if content
      where('name LIKE ? OR introduction LIKE ?', "%#{content}%", "%#{content}%")
    end
  end
end
