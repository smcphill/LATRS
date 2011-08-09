# controller for the admin section of the system. retrieves all templates known
# to the system
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class ManageController < ApplicationController
  def index
    @templates = Template.find(:all)
  end
end
