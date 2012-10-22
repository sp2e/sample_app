class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

	
  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # sign in user immediately after successful sign_up
      #so user by default is signed in after signing up.
      sign_in @user
      
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
end
