include ApplicationHelper

#   originally "sign_in",
#   then, changed to "Valid_signin" during optional cucumber section
# in chapter 7, i think it was
#   then , chapter 9, still kept it as sign_in, and
#had it start with "visit signin_path",
#which is redundant with valid information part of
#authenticity test...since it calls visit signin before the describe blocks.

# so I changed the name back to "sign_in", to keep the code identical
def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end