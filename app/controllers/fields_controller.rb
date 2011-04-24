class FieldsController < ApplicationController
  before_filter :update_table_config

  active_scaffold :fields do | config |
    config.label = "Form Fields"
    config.list.always_show_search = false
    config.actions.exclude  :search
    list.sorting = {:name => 'ASC'}

    #column definitions
    config.columns = :name, :is_general, :is_required, :limits, :children, :parent, :type, :is_multi, :par_hi_lim, :par_lo_lim
    config.list.columns = :name, :children, :limits, :type
    config.show.columns = :name, :suffix, :is_general, :is_required, :children, :limits, :type, :is_multi, :par_hi_lim, :par_lo_lim
    config.create.columns = :name, :suffix, :is_general, :is_required, :limits, :type, :is_multi, :par_hi_lim, :par_lo_lim
    config.update.columns = :name, :suffix, :is_general, :is_required, :type, :is_multi, :par_hi_lim, :par_lo_lim

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
    config.columns[:suffix].label = "Unit label"
    config.columns[:is_multi].label = "Multiple selection?"
    config.columns[:par_hi_lim].label = "Parent limit (upper)"
    config.columns[:par_lo_lim].label = "Parent limit (lower)"

    #descriptions
    config.columns[:name].description = "The name of this form field"
    config.columns[:is_general].description = "Does this field hold a general outcome for the test? Eg., 'Outcome = Positive' for Malaria"
    config.columns[:is_required].description = "A required field must be filled in for the test result to be saved"
    config.columns[:limits].description = "If this field data should be limited to a list of options, provide a set of limits here"
    config.columns[:children].description = "If this field has additional structure (like a Malaria PV classifier of 's', 't', or 'g'), create a subfield"
    config.columns[:type].description = "If this field holds number data, use the 'Number' type. Otherwise, use the 'Generic' type. This influences reporting"
    config.columns[:suffix].description = "Some fields should have a unit of measurement label; this will be displayed after the field. Eg. HCT Value: 55% ('%' is the label)"
    config.columns[:is_multi].description = "Can this field have multiple values? Note that this setting is ignored unless field limits are set"
    config.columns[:par_hi_lim].description = "Only display when the parent field value is lower than this"
    config.columns[:par_lo_lim].description = "Only display when the parent field value is higher than this"

  end

  def update_table_config
    if params[:id]
      @field = Field.find(params[:id])
      if !@field.parent_id
        active_scaffold_config.show.columns.exclude :par_hi_lim
        active_scaffold_config.create.columns.exclude :par_hi_lim
        active_scaffold_config.update.columns.exclude :par_hi_lim
        active_scaffold_config.show.columns.exclude :par_lo_lim
        active_scaffold_config.create.columns.exclude :par_lo_lim
        active_scaffold_config.update.columns.exclude :par_lo_lim
      else
        active_scaffold_config.show.columns.add :par_hi_lim
        active_scaffold_config.create.columns.add :par_hi_lim
        active_scaffold_config.update.columns.add :par_hi_lim
        active_scaffold_config.show.columns.add :par_lo_lim
        active_scaffold_config.create.columns.add :par_lo_lim
        active_scaffold_config.update.columns.add :par_lo_lim
      end
      
      if @field.limits.count() == 0
        active_scaffold_config.show.columns.exclude :is_multi
        active_scaffold_config.create.columns.exclude :is_multi
        active_scaffold_config.update.columns.exclude :is_multi
      else
        active_scaffold_config.show.columns.add :is_multi
        active_scaffold_config.create.columns.add :is_multi
        active_scaffold_config.update.columns.add :is_multi
      end
    end
  end

  # only want to filter out children when not nested or nested parent is not field
  def conditions_for_collection
    if (!params[:nested] or (params[:nested] and params[:parent_model] != "Field"))
      ['fields.parent_id IS NULL']
    end
  end
end
