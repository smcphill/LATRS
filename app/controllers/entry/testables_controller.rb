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

    #search
    config.field_search.columns = :datatype, :patient, :staff, :department, :time_in
    config.columns[:datatype].search_ui = :select


    #sort
    config.columns[:time_in_str].sort_by :sql => "time_in"

    #subtests
    config.nested.add_link("Sub-tests", :subtests)
    config.columns[:subtests].association.reverse = :master
  end

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
    if (save_params[:patient_id] and not save_params[:patient_id][:rn].blank?)
      patient = Patient.find_by_rn(save_params[:patient_id][:rn])
      if not patient.nil?
        save_params[:patient_id] = patient.id
      else
        save_params[:patient_id] = nil
      end
    end
    @testable = Testable.new(save_params)
    if @testable.save
      flash[:notice] = "Data entry complete"
      redirect_to :action => 'index', :controller => '/entry'
    else
      @form ||=YAML::load(params[:form])
      flash.now[:error] = @testable.errors
      @testable = Testable.new(params[:testable])
      @testable.add_lost_subtests(@form.subtests)

      render :action => 'new'
    end
  end

  def auto_complete_for_patient_rn
    if params[:pid].nil?
      @p = nil
    else
      pid = params[:pid].to_s.downcase + "%"
      @p = Patient.all(:conditions => ["lower(rn) like ?", pid])
    end
      render :action => 'autocomplete'
  end

  # do we want the first or the last one?
  def similar
    @t = Testable.last :joins => :patient, 
                       :conditions => { 
                         :patients => { :rn => params[:rn] } }

    respond_to do |format|
      format.js
    end
  end
end
