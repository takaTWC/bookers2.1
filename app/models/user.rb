class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
    # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followings, through: :reverse_of_relationships, source: :following
  
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "following_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followers, through: :relationships, source: :follower
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50}


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user) #フォロー時の処理
    relationships.create(follower_id: user.id)
  end

  def unfollow(user) #アンフォロー時の処理
    relationships.find_by(follower_id: user.id).destroy
  end

  def following?(user) #フォローしていればTRUEを返す
    followers.include?(user)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end
