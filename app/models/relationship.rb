class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  #ensures that the follower_id isn’t accessible
  #why must this be done?
  
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

end
