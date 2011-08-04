class Manage::GroupsController < ApplicationController

  active_scaffold :groups do | config |
    config.label = "Field Groups"
    config.list.always_show_search = false
    config.list.pagination = false
    config.list.per_page = 1000
    config.actions.exclude  :search, :show
    list.sorting = {:name => 'ASC'}
    config.create.link.label = "Add Group"
    config.update.link = false
    config.list.empty_field_text = "[empty]"

    #sorting
    config.actions << :sortable
    config.sortable.column = :position

    #column definitions
    config.columns = :name, :description, :template, :fields
    config.list.columns = :name, :description, :fields
    config.create.columns = :name, :description, :template
    config.update.columns = :name, :description, :template

    #associations
    config.nested.add_link("Fields", :fields)
    config.columns[:fields].clear_link
    config.columns[:fields].associated_limit = 100

    #labels
    config.columns[:name].label = "Group"
    
    # form overrides
    config.columns[:name].inplace_edit = true
    config.columns[:description].inplace_edit = true
    config.columns[:fields].send_form_on_update_column = true
  end
  
  def after_create_save(record)
    curr_pos = Group.maximum("position", :conditions => "template_id = #{record.template_id}")
    curr_pos ||= 0
    record.position =  curr_pos + 1
    record.save
  end

end
