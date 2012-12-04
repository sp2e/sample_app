class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  # this filter creates an extra level of security, alhtough unlikely to be needed
  # Users controller already requires a signed-in-user 
  #before the follow or unfollow buttons can be successfully used.
  # We also need signed in users for the create and destroy actions below.
  #they would likely catch all unsigned users by themselves,
  #via the second line of code in each action ("current_user.....")
  #since no current user would exist : current-user would be 'nil'
  #But the above filter provides an extra level of security 
  #by not solely depending on the 2nd line.

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    #redirect_to @user 
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    #redirect_to @user 
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end