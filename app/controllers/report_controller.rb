class ReportController < ApplicationController
  layout "report"

  def index
    @templates = Template.all(:conditions => ["id IN (?)",
                                              FormManager.instance.activeForms])
  end
end
