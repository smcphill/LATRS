class Manage::TemplatesController < ApplicationController
  layout "manage"
  active_scaffold :templates do | config |
    config.label = "Forms"
    config.list.always_show_search = false
    config.list.pagination = false
    config.list.per_page = 1000
    config.actions.exclude  :search    
    config.list.sorting = {:name => 'ASC'}
    config.list.empty_field_text = "[empty]"

    config.create.action_after_create = 'show'

    #column definitions
    config.columns = :name, :description, :colour, :is_active, :groups, :ancestors, :descendants, :testables
    config.list.columns = :name, :is_active, :groups, :descendants
    config.show.columns = :name, :description, :is_active, :colour, :groups, :descendants
    config.create.columns = :name, :description, :colour
    config.update.columns = :name, :description, :colour, :is_active    

    #associations
    config.columns[:groups].clear_link
    config.columns[:groups].associated_limit = 100
    config.columns[:groups].includes = [:fields]
    config.columns[:descendants].clear_link
    config.columns[:descendants].associated_limit = 100
    config.columns[:descendants].actions_for_association_links = [:show]
    config.nested.add_link("Form Fields", :fields)    
    config.nested.add_link("Sub-tests", :descendants)

    #labels
    config.columns[:name].label = "Form Name"
    config.columns[:is_active].label = "Status"
    config.columns[:groups].label = "Form Fields"
    config.columns[:descendants].label = "Sub-tests"
    
    #form overrides
    config.columns[:is_active].inplace_edit = true
    config.columns[:colour].inplace_edit = :ajax

    #descriptions
    config.columns[:name].description = "The name of the form"
    config.columns[:description].description = "Explanatory text for this form"
    config.columns[:colour].description = "The data entry form for this test will be this colour"
    config.columns[:is_active].description = "If selected, this form will be available for people to use"
    config.columns[:groups].description = "Fields to be shown in the form"
    config.columns[:descendants].description = "These forms will be displayed upon completion of this form, pre-populated with patient, staff and department data"
    
  end
  
  def index
    redirect_to :controller => '/manage', :action => 'index'
  end

  def render_field
    if (params[:column] == "colour" &&
        params[:in_place_editing] == "true")
      render :partial => "inplace_colour", :locals => {:record => Template.find(params[:id]) }
    else
      super
    end
  end
end
