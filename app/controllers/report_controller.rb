class ReportController < ApplicationController
  layout "report"

  def index
#    @templates = Template.all(:conditions => ["id IN (?)",
#                                              FormManager.instance.activeForms])
  end

  def custom
    report_params = session['as:report/testables'][:search]
    if not report_params.has_key?(:datatype) or report_params[:datatype].blank?
      flash[:error] = "Please select a test type"
      redirect_to :action => 'index', :controller => '/report/testables' 
    else
      parser = Latrs::Search::Parser.new(report_params)
      tests = Testable.all(:conditions => parser.parse, :joins => :testableitems)
      render :text => report_params.inspect + "\n\n" + parser.parse.to_s + "\n\n" + tests.inspect
    end
  end

end
