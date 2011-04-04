class TemplatesController < ApplicationController
  active_scaffold :templates do | config |
    config.label = "Test Templates"
    config.columns = :name, :is_active, :fields, :children
    config.list.columns = :name, :is_active, :children, :fields
    config.columns[:fields].clear_link
    config.columns[:fields].associated_limit = 10
    config.columns[:children].clear_link
    config.columns[:children].associated_limit = 10

    list.sorting = {:name => 'ASC'}
    config.nested.add_link("Data Fields", :fields)    
    config.nested.add_link("Children", :children)    
  end
end
