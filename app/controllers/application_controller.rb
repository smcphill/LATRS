# This is the application's main "Controller"; this is 
# the request/response mechanism for Ruby on Rails
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  protect_from_forgery
end
