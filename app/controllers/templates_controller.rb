class TemplatesController < ApplicationController
  active_scaffold :templates do | config |
    config.label = "Forms"
    config.list.always_show_search = false
    config.actions.exclude  :search    
    config.columns = :name, :is_active, :fields, :ancestors, :descendants
    config.list.columns = :name, :is_active, :fields, :descendants
    config.columns[:name].label = "Form Name"
    config.columns[:is_active].label = "Active?"
    config.columns[:fields].label = "Form Fields"
    config.columns[:descendants].label = "Sub-tests"
    config.columns[:fields].clear_link
    config.columns[:fields].associated_limit = 10
    config.columns[:descendants].clear_link
    config.columns[:descendants].associated_limit = 10
    config.columns[:descendants].actions_for_association_links = [:show]
    list.sorting = {:name => 'ASC'}
    config.nested.add_link("Form Fields", :fields)    
    config.nested.add_link("Sub-tests", :descendants)    
    config.create.columns = :name, :is_active
    config.update.columns = :name, :is_active
    
  end
end
