class TemplatesController < ApplicationController
  active_scaffold :templates do | config |
    config.label = "Forms"
    config.list.always_show_search = false
    config.actions.exclude  :search    
    list.sorting = {:name => 'ASC'}
    
    #column definitions
    config.columns = :name, :is_active, :fields, :ancestors, :descendants
    config.list.columns = :name, :is_active, :fields, :descendants
    config.create.columns = :name
    config.update.columns = :name, :is_active    

    #associations
    config.columns[:fields].clear_link
    config.columns[:fields].associated_limit = 10
    config.columns[:descendants].clear_link
    config.columns[:descendants].associated_limit = 10
    config.columns[:descendants].actions_for_association_links = [:show]
    config.nested.add_link("Form Fields", :fields)    
    config.nested.add_link("Sub-tests", :descendants)    

    #labels
    config.columns[:name].label = "Form Name"
    config.columns[:is_active].label = "Active?"
    config.columns[:fields].label = "Form Fields"
    config.columns[:descendants].label = "Sub-tests"
    
    #form overrides
    config.columns[:is_active].form_ui = :checkbox

    #descriptions
    config.columns[:name].description = "The name of the form"
    config.columns[:is_active].description = "If selected, this form will be available for people to use"
    config.columns[:fields].description = "Fields to be shown in the form"
    config.columns[:descendants].description = "These forms will be displayed upon completion of this form, pre-populated with patient, tester, department and source data"
    
  end

end
