class Manage::DepartmentsController < ApplicationController
  layout "manage"
  active_scaffold :departments do | config |
    config.label = "Departments"
    config.columns = [:name]
    config.list.always_show_search = false
    config.list.pagination = false
    config.list.per_page = 1000
    config.actions.exclude :show, :search
    config.create.link.label = "Add Department"
    config.update.link = false
    config.columns[:name].inplace_edit = true   
  end

  def index
    redirect_to :controller => '/manage', :action => 'index'
  end
  
end
