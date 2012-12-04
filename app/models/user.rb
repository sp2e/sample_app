# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
#simple explanation: "source: :followed"
#means that "followed_users" is the plural
# of "followed"  
=begin
  has_many :followed_users, through: :relationships, source: :followed

  would assemble an array using the followed_id in the relationships table. But, as noted in Section 11.1.1, user.followeds is rather awkward; far more natural is to use “followed users” as a plural of “followed”, and write instead user.followed_users for the array of followed users. Naturally, Rails allows us to override the default, in this case using the :source parameter (Listing 11.10), which explicitly tells Rails that the source of the followed_users array is the set of followed ids.
=end

  has_many :reverse_relationships, foreign_key: "followed_id",
          class_name:  "Relationship", dependent:   :destroy
=begin
Note that we actually have to include the class name for this association, i.e.,
has_many :reverse_relationships, foreign_key: "followed_id",
                                 class_name: "Relationship"
because otherwise Rails would look for a ReverseRelationship class, which doesn’t exist.
=end
  has_many :followers, through: :reverse_relationships
  #, source: :follower
  # above commented line could be included in above for instructional emphasis, but it is not needed

  #before_save { |user| user.email = email.downcase }
  #following is equivalent, easier to read
  before_save {self.email.downcase!}
  before_save :create_remember_token


  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed

    Micropost.from_users_followed_by(self)

    #Micropost.where("user_id = ?", id)
    # This is preliminary. See "Following users" for the full implementation.
    #equivalent to simply, 
    #microposts
    #We’ve used the code in Listing 10.39 instead 
    #because it generalizes much more naturally to the
    # full status feed needed in Chapter 11.
  end
=begin   NOTE about ABOVE:
The question mark in

Micropost.where("user_id = ?", id)

ensures that id is properly escaped before being 
included in the underlying SQL query, thereby avoiding
a serious security hole called SQL injection. The id
attribute here is just an integer, so there is no   danger in this case, but always escaping variables
injected into SQL statements is a good habit to 
cultivate.
=end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  
  def follow!(other_user)
    #"follow!" : note comment below
    relationships.create!(followed_id: other_user.id)
    #equivalent: self.relationships.create!(...)
    #which to use is a matter of taste.
  end
=begin
(This follow! method should always work, so, as with create! and save!, we indicate with an exclamation point that an exception will be raised on failure.)
=end  

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end

