# Controller for the data entry section. Retrieves all active templates
# that can be used to create new test results
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details

class EntryController < ApplicationController
  layout "entry"
  def index
    @templates = Template.all(:conditions => ["id IN (?)",
                                               FormManager.instance.activeForms])
  end
end
