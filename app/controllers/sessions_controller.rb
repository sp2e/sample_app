class SessionsController < ApplicationController
  def new
  end

  def create

=begin code before exercise  8.5.1 
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_to user
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = 'Invalid email/password combination' 
      render 'new'

    end 
=end 

# exercise code per exercise 8.5.1...........
# NOTE difference in params from above
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      # Sign the user in and 
      #redirect to the user's show page,
      #or redirect to the session stored page 
      #if user tried to go somewhere before signing in
      sign_in user
      redirect_back_or user
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = 'Invalid email/password combination' 
      render 'new'

    end 
# end exercise code per exercise 8.5.1

  end

  def destroy
    sign_out  #see sessions helper module for sign_out fundtion
    redirect_to root_url  
  end
end
