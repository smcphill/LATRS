class TemplatesController < ApplicationController
  active_scaffold :templates do | config |
    config.label = "Test Templates"
    config.columns = :name, :is_active, :fields
    config.list.columns = :name, :is_active
    list.sorting = {:name => 'ASC'}
    config.nested.add_link("Data Fields", :fields)    
  end
end
