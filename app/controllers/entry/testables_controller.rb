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

  def create
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
