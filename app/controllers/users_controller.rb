class UsersController < ApplicationController
  #:index, :edit, and :update actions are only allowed by signed in users
  before_filter :signed_in_user, only: [:index,:edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :signed_in_user_to_root_path,   only: [:new, :create]

  def show
    @user = User.find(params[:id])
    #@microposts = @user.microposts.paginate(page: params[:page])
    #  @item = User.new

    params[:search] = {"name" => ""} unless params[:search]
    #Rails.logger.info("+++++ params is #{params}")
    @search = Search.new(:micropost, params[:search])
    @search.add_conditions("user_id" => @user.id)
    #Rails.logger.info("====== condtions is #{@search.conditions}")

    @microposts = Micropost.paginate(page: params[:page], :conditions => @search.conditions, :joins => @search.joins)
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # sign in user immediately after successful sign_up
      #so user by default is signed in after signing up.
      #sign_in  is in sessions_helper
      sign_in @user
      
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    #"@user...." line below is not needed
    # since "before filter" (above)
    #calls correct_user function, defined below
    #in private

    # @user = User.find(params[:id])

  end

  def update
    #"@user...." line below is not needed
    # since "before filter" (above)
    #calls correct_user function, defined below
    #in private

    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user    
      #Note that we sign in the user 
      #as part of a successful profile update; 
      #this is because the remember token gets reset 
      #when the user is saved (Listing 8.18), 
      #which invalidates the user’s session (Listing 8.22).
      # This is a nice security feature, 
      #as it means that any hijacked sessions 
      #will automatically expire 
      #when the user information is changed. 
    else
      render 'edit'
    end
  end

  def index
  #code before pagination
  # @users = User.all

    @users = User.paginate(page: params[:page])
  end

  def destroy
    # puts "destory entered"
    usad = (User.find(params[:id]))
    if !current_user?(usad)
    usad.destroy
    flash[:success] = "User destroyed."
    end
    redirect_to users_url
  end

  private 
  #no "end" statement for private, so private must always live at end of file.

    #moved to SessionsHelper
    #def signed_in_user
    #end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_in_user_to_root_path
      if signed_in?
        redirect_to root_path
      end
    end
end
