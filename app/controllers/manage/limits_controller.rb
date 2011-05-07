class Manage::LimitsController < ApplicationController
  layout "manage"
  active_scaffold :limits do | config |
    config.list.always_show_search = false
    config.list.pagination = false
    config.list.per_page = 1000
    config.actions.exclude  :search, :show
    config.columns = :name, :is_default, :field
    config.update.link = false
    config.create.link.label = "Add Limit"

    #sorting
    config.actions << :sortable
    config.sortable.column = :position

    #labels
    config.columns[:name].label = "Value"
    config.columns[:is_default].label = "Default option?"
    config.columns[:is_default].send_form_on_update_column = true

    # form overrides
    config.columns[:is_default].form_ui = :checkbox
    config.columns[:name].inplace_edit = true
    config.columns[:is_default].inplace_edit = true

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
