# controller for dealing with patients in data entry
# a lot of the heavy lifting is done by ActiveScaffold
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Entry::PatientsController < ApplicationController
  layout "entry", :except => [:rn]
  active_scaffold :patients do | config |
    config.label = "Patients"
    config.columns = [:name, :rn, :age, :birthdate, :gender, :ethnicity, :location]
    config.list.pagination = true
    config.list.per_page = 20
    config.actions.exclude :delete, :create, :update
    config.actions = [:nested, :list, :show, :field_search]


    #labels
    config.columns[:rn].label = "Patient RN"

    config.list.columns = [:name, :rn, :age, :gender, :ethnicity]
    config.show.columns = [:rn, :age, :birthdate, :gender, :ethnicity, :location]

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

  # find a patient by RN. This is used for some AJAXy goodness
  def rn
    if (params[:id].nil?)
      render :text => "<p>Enter the patient's RN to retrieve details</p>"
    else
      @record = Patient.find_by_rn(params[:id])
      if @record.nil?
        render :action => 'nopatient'
      else
        render :action => 'show'
      end
    end
  end
end
