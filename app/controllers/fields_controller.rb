class FieldsController < ApplicationController
  active_scaffold :fields do | config |
    config.label = "Data Fields"
    config.columns = :name, :is_general, :is_required, :limits
    config.list.columns = :name, :is_general, :is_required
    list.sorting = {:name => 'ASC'}
    config.nested.add_link("Field Limits", :limits)    
    config.columns[:limits].association.reverse = :field

  end
end
