class FieldsController < ApplicationController
  active_scaffold :fields do | config |
    config.label = "Form Fields"
    config.list.always_show_search = false
    config.actions.exclude  :search
    config.columns = :name, :is_general, :is_required, :limits, :children, :parent, :type
    config.list.columns = :name, :template, :children, :limits, :type
    config.columns[:name].label = "Field"
    config.columns[:template].label = "Form"
    config.columns[:limits].clear_link
    config.columns[:limits].associated_limit = 10
    config.columns[:children].actions_for_association_links = [:show]
    config.columns[:children].label = "Subfields"
    config.columns[:template].actions_for_association_links = [:show]
    config.columns[:children].form_ui = :select
    config.columns[:type].form_ui = :select

    list.sorting = {:name => 'ASC'}
    config.nested.add_link("Limits", :limits)    
    config.nested.add_link("Subfields", :children)    
    config.create.columns = :name, :is_general, :is_required, :limits, :type
    config.update.columns = :name, :is_general, :is_required, :type

  end

  # only want to filter out children when not nested or nested parent is not field
  def conditions_for_collection
    if (!params[:nested] or (params[:nested] and params[:parent_model] != "Field"))
      ['fields.parent_id IS NULL']
    end
  end
end
