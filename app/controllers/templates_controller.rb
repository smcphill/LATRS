class TemplatesController < ApplicationController
  active_scaffold :templates do | config |
    config.label = "Test Templates"
    config.list.always_show_search = false
    config.actions.exclude  :search    
    config.columns = :name, :is_active, :fields, :ancestors, :descendants
    config.list.columns = :name, :is_active, :fields, :descendants
    config.columns[:fields].clear_link
    config.columns[:fields].associated_limit = 10
    config.columns[:descendants].clear_link
    config.columns[:descendants].label = "Sub-tests"
    config.columns[:descendants].associated_limit = 10
    config.columns[:descendants].actions_for_association_links = [:show]
    list.sorting = {:name => 'ASC'}
    config.nested.add_link("Data Fields", :fields)    
    config.nested.add_link("Children", :descendants)    
  end
end
