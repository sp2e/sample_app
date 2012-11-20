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
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
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

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end

