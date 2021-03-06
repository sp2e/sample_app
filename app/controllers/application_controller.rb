class ApplicationController < ActionController::Base
=begin
protect_from_forgery - A feature in Rails that protects 
against Cross-site Request Forgery (CSRF) attacks.
 This feature makes all generated forms have a hidden id field. 
 This id field must match the stored id or 
 the form submission is not accepted. 
 T his prevents malicious forms on other sites or 
 forms inserted with XSS from submitting to the Rails application.
=end
  protect_from_forgery

  include SessionsHelper
end
