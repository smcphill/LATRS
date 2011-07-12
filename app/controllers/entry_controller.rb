class EntryController < ApplicationController
  layout "entry"
  def index
    @templates = Template.all(:conditions => ["id IN (?)",
                                               FormManager.instance.activeForms])
  end
end
