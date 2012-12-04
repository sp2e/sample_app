class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  #order of microposts to be in descending order, newest to oldest
  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
  	#see end of chapter 11 in rails_tutorial for the development of this code
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end

end
