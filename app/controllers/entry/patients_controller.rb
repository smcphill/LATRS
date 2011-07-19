class Entry::PatientsController < ApplicationController
  layout "entry", :except => [:rn]
  active_scaffold :patients do | config |
    config.label = "Patients"
    config.columns = [:name, :rn, :age, :birthdate, :gender, :ethnicity, :height, :weight, :location]
    config.list.pagination = true
    config.list.per_page = 20
    config.actions.exclude :delete, :create, :update
    config.actions = [:nested, :list, :show, :field_search]


    #labels
    config.columns[:rn].label = "Patient RN"
    config.columns[:height].label = "Height (cm)"
    config.columns[:weight].label = "Weight (kg)"

    config.list.columns = [:name, :rn, :age, :gender, :ethnicity]
    config.show.columns = [:rn, :age, :birthdate, :gender, :ethnicity, :height, :weight, :location]

    #form options
    config.columns[:gender].form_ui = :select
    config.columns[:gender].options = {:options => Patient::GENDER.map(&:to_sym)}

    #search
    config.field_search.columns = :name, :rn, :gender, :ethnicity, :birthdate

    #sort
    config.columns[:age].sort_by :sql => "birthdate"

    #patient history
    config.nested.add_link("History", :testables)    
    config.columns[:testables].associated_limit = 100

  end
  
  def rn
    if (params[:id].nil?)
      render :text => "<p>Enter the patient's RN to retrieve details</p>"
    else
      @record = Patient.find_by_rn(params[:id])
      render :action => 'show', :locals => {@record => @record}
    end
  end
end
