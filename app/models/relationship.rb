class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  def follow(user_id) #フォロー時の処理
    followers.create(followed_id: user_id)
  end
  
  def unfollow(user_id) #アンフォロー時の処理
    follower.find_by(followed_id: user_id).destroy
  end
  
  def following?(user) #フォローしていればTRUEを返す
    following_users.include?(user)
  end
end
