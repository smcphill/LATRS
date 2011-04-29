class ManageController < ApplicationController
  def index
    @templates = Template.find(:all)
  end
end
