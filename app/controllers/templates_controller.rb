class TemplatesController < ApplicationController
  active_scaffold :templates do | config |
    config.label = "Test Templates"
    config.columns = :name, :is_active, :fields
    config.list.columns = :name, :is_active, :fields
    config.columns[:fields].clear_link
    config.columns[:fields].associated_limit = 10

    list.sorting = {:name => 'ASC'}
    config.nested.add_link("Data Fields", :fields)    
  end
end
