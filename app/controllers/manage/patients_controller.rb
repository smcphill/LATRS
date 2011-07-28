class Manage::PatientsController < ApplicationController
  
  layout "manage", :except => [:rn]
  active_scaffold :patients do | config |
    config.label = "Patients"
    config.columns = [:name, :rn, :age, :birthdate, :gender, :ethnicity, :location]
    config.list.pagination = true
    config.list.per_page = 20
    config.actions.exclude :show
  
    #labels
    config.create.link.label = "Add Patient"
    config.columns[:rn].label = "Patient RN"
    
    config.list.columns = [:name, :rn, :age, :gender, :ethnicity]
    config.create.columns = [:name, :rn, :birthdate, :gender, :ethnicity, :location]
    config.update.columns = [:name, :rn, :birthdate, :gender, :ethnicity, :location]

    #form options
    config.columns[:gender].form_ui = :select
    config.columns[:gender].options = {:options => Patient::GENDER.map(&:to_sym)}
  end

  def index
    redirect_to :controller => '/manage', :action => 'index'
  end
end
