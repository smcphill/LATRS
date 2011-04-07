class FieldsController < ApplicationController
  active_scaffold :fields do | config |
    config.label = "Form Fields"
    config.list.always_show_search = false
    config.actions.exclude  :search
    list.sorting = {:name => 'ASC'}

    #column definitions
    config.columns = :name, :is_general, :is_required, :limits, :children, :parent, :type
    config.list.columns = :name, :template, :children, :limits, :type
    config.create.columns = :name, :is_general, :is_required, :limits, :type
    config.update.columns = :name, :is_general, :is_required, :type

    #associations
    config.nested.add_link("Limits", :limits)    
    config.nested.add_link("Subfields", :children)
    config.columns[:limits].clear_link
    config.columns[:limits].associated_limit = 10
    config.columns[:children].actions_for_association_links = [:show]
    config.columns[:children].clear_link
    config.columns[:children].label = "Subfield"
    config.columns[:children].form_ui = :select
    config.columns[:children].association.reverse = :parent 
    config.columns[:children].includes = [] 
    config.columns[:template].actions_for_association_links = [:show]
    config.columns[:type].form_ui = :select
    
    #labels
    config.columns[:name].label = "Field"
    config.columns[:template].label = "Form"

    #descriptions
    config.columns[:name].description = "The name of this form field"
    config.columns[:is_general].description = "Does this field hold a general outcome for the test? Eg., 'Outcome = Positive' for Malaria"
    config.columns[:is_required].description = "A required field must be filled in for the test result to be saved"
    config.columns[:limits].description = "If this field data should be limited to a list of options, provide a set of limits here"
    config.columns[:children].description = "If this field has additional structure (like a Malaria PV classifier of 's', 't', or 'g'), create a subfield"
    config.columns[:type].description = "If this field holds number data, use the 'Number' type. Otherwise, use the 'Generic' type. This influences reporting"


  end

  # only want to filter out children when not nested or nested parent is not field
  def conditions_for_collection
    if (!params[:nested] or (params[:nested] and params[:parent_model] != "Field"))
      ['fields.parent_id IS NULL']
    end
  end
end
