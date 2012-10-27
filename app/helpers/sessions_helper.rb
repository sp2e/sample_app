module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token

=begin
It’s worth noting that our test suite 
covers most of the authentication machinery, 
but not all of it. For instance, 
we don’t test how long the “remember me” cookie lasts 
or whether it gets set at all. 
It is possible to do so, but experience shows that 
direct tests of cookie values are brittle 
and have a tendency to rely on implementation details 
that sometimes change from one Rails release to the next. 
The result is breaking tests for application code that still works fine. 
By focusing on high-level functionality—verifying that users can sign in, 
stay signed in from page to page, 
and can sign out—we test the core application code 
without focusing on less important details.
=end
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end
 
  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

end
