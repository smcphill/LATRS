class Manage::PatientsController < ApplicationController
  layout "manage"
  active_scaffold :patients do | config |
    config.label = "Patients"
    config.columns = [:name, :rn]
    config.list.pagination = true
    config.list.per_page = 20
    config.actions.exclude :show
    config.create.link.label = "Add Patient"
    config.columns[:rn].label = "Patient RN"
  end

  def index
    redirect_to :controller => '/manage', :action => 'index'
  end
end
