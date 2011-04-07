class LimitsController < ApplicationController
  active_scaffold :limits do | config |
    config.list.always_show_search = false
    config.actions.exclude  :search    
    config.columns = :name, :is_default, :field
    
    #labels
    config.columns[:name].label = "Value"
    config.columns[:is_default].label = "Default option?"

    #descriptions
    config.columns[:name].description = "This will become a selectable option for the form field"
    config.columns[:is_default].description = "This will make this option the default selection for the form field"
  end

  def after_update_save(record)
    if (record.is_default)
      Limit.all(:conditions => 
                ["field_id = ? AND id != ?", record.field_id, record.id]).each do |l|
        l.is_default = false
        l.save
      end
    end
  end
end
