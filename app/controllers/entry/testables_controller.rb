class Entry::TestablesController < ApplicationController
  layout "entry", :except => [:auto_complete_for_patient_rn]

  def new
    if (FormManager.instance.hasForm(params[:tid]))
      @form = FormManager.instance.getForm(params[:tid])
      @testable = Testable.new
      @testable.datatype = @form.className      
      @form.nbr_fields.times { @testable.testableitems.build }
      @form.subtests.count.times { @testable.subtests.build }
      @testable.subtests.each_with_index do |s,i|
        @form.subtests[i].nbr_fields.times {s.testableitems.build}
      end
    else
      flash[:error] = "This test isn't active; please try again";
      redirect_to :action => 'index'
    end
  end

  def prep_create(items)
    items.each_pair do |key,val|
      item = items[key]
      transKey = Integer(items.keys.max {|a,b| Integer(a) <=> Integer(b) })

      while item[:value].kind_of?(Array)
        transKey += 1
        items["#{transKey.to_s}"] = item.dup
        items["#{transKey.to_s}"][:value] = item[:value].pop
        if item[:value].count == 1
          item[:value] = item[:value].first
        end
      end
      
    end
    return items
  end

  def create

    params[:testable][:testableitems_attributes] = prep_create(params[:testable][:testableitems_attributes])
    if params[:testable].has_key?(:subtests_attributes)
      params[:testable][:subtests_attributes].each_pair do |key,subtest|
        subtest[:testableitems_attributes] = prep_create(subtest[:testableitems_attributes])
        subtest[:time_in] = params[:testable][:time_in]
        subtest[:time_out] = params[:testable][:time_out]
        subtest[:source_id] = params[:testable][:source_id]
        subtest[:staff_id] = params[:testable][:staff_id]
        subtest[:patient_id] = params[:testable][:patient_id]
        subtest[:department_id] = params[:testable][:department_id]
      end
    end
    @testable = Testable.new(params[:testable])
    if @testable.save
      flash[:notice] = "Data entry complete"
      redirect_to :action => 'index'
    else
      flash[:error] = @testable.errors
      render :action => 'new'
    end
  end

  def auto_complete_for_patient_rn
    pid = params[:pid].to_s.downcase + "%"
    @p = Patient.all(:conditions => ["lower(rn) like ?", pid])
    render :action => 'autocomplete'
  end

  def index
    redirect_to :controller => '/entry', :action => 'index'
  end
end
