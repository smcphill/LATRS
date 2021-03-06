# controller for dealing with tests in data entry
# a lot of the heavy lifting is done by ActiveScaffold
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Entry::TestablesController < ApplicationController
  layout "entry", :except => [:auto_complete_for_patient_rn, :similar]
  active_scaffold :testables do | config |
    config.label = "Test Results"
    config.list.pagination = true
    config.list.per_page = 20
    config.actions.exclude :create, :update
    config.actions = [:nested, :list, :show, :delete, :field_search]

    config.columns = [:time_in_str, :datatype, :department, :staff, :patient, :time_taken, :subtests, :master]
    config.list.columns = [:time_in_str, :datatype, :department, :staff, :patient, :time_taken]
    config.show.columns = [:time_in_str, :department, :staff, :patient, :time_taken]
    
    #labels
    config.columns[:datatype].label = "Type"
    config.columns[:time_in_str].label = "Requested"
    config.columns[:patient].label = "Patient (RN)"

    #search
    config.field_search.columns = :datatype, :patient, :staff, :department, :time_in
    config.columns[:datatype].search_ui = :select
    config.columns[:patient].search_ui = :string
    config.columns[:patient].search_sql = "patients.rn"
    config.columns[:patient].options[:string_comparators] =  true
    config.columns[:patient].options[:null_comparators] =  false

    #sort
    config.columns[:time_in_str].sort_by :sql => "time_in"
    config.columns[:patient].sort_by :sql => "patients.name"

    #subtests
    config.nested.add_link("Sub-tests", :subtests)
    config.columns[:subtests].association.reverse = :master
  end

  # creating a new test result is a bit tricky, because
  # there are nested associations. We need to build up
  # placeholders for all the potential nested associations
  # (fields, subtests, fields of subtests)
  def new
    if (FormManager.instance.hasForm(params[:tid]))
      @form = FormManager.instance.getForm(params[:tid])
      @testable = Testable.new
      @testable.datatype = @form.name      
      @form.nbr_fields.times { @testable.testableitems.build }
      @form.subtests.count.times { @testable.subtests.build }
      @testable.subtests.each_with_index do |s,i|
        @form.subtests[i].nbr_fields.times {s.testableitems.build}
      end
    else
      flash[:error] = "This test isn't active; please try again";
      redirect_to :action => 'index', :controller => '/entry'
    end
  end

  # preview the test. this doesn't require the test to be active
  # and disables all form elements
  def preview
    @form = FormManager.instance.previewForm(params[:id])
    @testable = Testable.new
    @testable.datatype = @form.name      
    @form.nbr_fields.times { @testable.testableitems.build }
    @form.subtests.count.times { @testable.subtests.build }
    @testable.subtests.each_with_index do |s,i|
      @form.subtests[i].nbr_fields.times {s.testableitems.build}
    end
    @form.description = "<span style='color:red'>This is a <b>preview</b> of the form</span><br/>#{@form.description}"
    render :layout => 'preview'
  end

  # before we actually create a new test, we need to rejig
  # repeated items (multiple-valued fields) to get them into 
  # a format that will work with nested associations
  def prep_create(items)
    items.each_pair do |key,item|
      transKey = Integer(items.keys.max {|a,b| Integer(a) <=> Integer(b) })

      while item[:value].kind_of?(Array)
        if item[:value].count == 1
          item[:value] = item[:value].first
        else
          transKey += 1
          items["#{transKey.to_s}"] = item.dup
          items["#{transKey.to_s}"][:value] = item[:value].pop
        end
      end
      # now, strip out non-required empty values
      items.delete(key) if item[:value].blank? and item[:required] != "true"
    end

    return items
  end

  # creating a new test result is a bit hairy. There are many places
  # where this can go wrong (required fields, required fields in subtests)
  # and also a fair bit of structural massaging that goes on
  def create
    if params[:testable][:patient_id][:rn].blank?
      params[:testable].delete(:patient_id)
    end
    save_params = params[:testable].dup
    save_params[:testableitems_attributes] = prep_create(save_params[:testableitems_attributes])
    if save_params.has_key?(:subtests_attributes)
      save_params[:subtests_attributes].each_pair do |key,subtest|
        next if subtest[:saveme] == "false"
        subtest[:testableitems_attributes] = prep_create(subtest[:testableitems_attributes])
        subtest[:time_in] = save_params[:time_in]
        subtest[:time_out] = save_params[:time_out]
        subtest[:staff_id] = save_params[:staff_id]
        subtest[:patient_id] = save_params[:patient_id]
        subtest[:department_id] = save_params[:department_id]
      end
    end
    # i don't know why, but our nested patient info isn't triggering the correct
    # association. i have something like params[:testable][:patient_id][:rn], but
    # this is getting ignored, and the first patient in the db is being used.
    # let's fix this. we already know that the RN is (mostly) correct, but it
    # isn't a required field anyway...
    if (save_params[:patient_id] and not save_params[:patient_id][:rn].blank? and not save_params[:patient_id][:rn].nil?)
      patient = Patient.find_by_rn(save_params[:patient_id][:rn])
      if not patient.nil?
        save_params[:patient_id] = patient.id
      else
        save_params[:patient_id] = nil
      end
    else
      save_params[:patient_id] = nil      
    end
    @testable = Testable.new(save_params)
    if @testable.save
      flash[:notice] = "Data entry complete"
      redirect_to :action => 'index', :controller => '/entry'
    else
      @form ||=YAML::load(params[:form])
      flash.now[:error] = @testable.errors
      @testable = Testable.new(params[:testable])
      begin
        patient = Patient.find_by_rn(params[:testable][:patient_id][:rn])
        @testable.patient = patient
      rescue
        @testable.patient = nil
      end
      @testable.add_lost_subtests(@form.subtests)

      render :action => 'new'
    end
  end

  # this should probably be in the patient controller. it's used to 
  # provide an auto-complete list of patients already in the 
  # system, as opposed to the HealthInfoController
  def auto_complete_for_patient_rn
    if params[:pid].nil?
      @p = nil
    else
      pid = params[:pid].to_s.downcase + "%"
      @p = Patient.all(:conditions => ["lower(rn) like ?", pid])
    end
      render :action => 'autocomplete'
  end

  # once we have a patient, we want to retrieve that patient's 
  # most recent test and use its details for department, staff
  # and times
  def similar
    @t = Testable.last :joins => :patient, 
                       :conditions => { 
                         :patients => { :rn => params[:rn] } }

    respond_to do |format|
      format.js
    end
  end
end
