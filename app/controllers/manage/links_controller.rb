class Manage::LinksController < ApplicationController
  layout "manage"
  active_scaffold :links do | config |
    config.label = "Sub-Test Links"
    config.columns = :descendant, :ancestor
    config.columns[:ancestor].label = "Sub-test"
    config.columns[:ancestor].clear_link
    config.columns[:ancestor].form_ui = :select
    config.list.always_show_search = false
    config.actions.exclude :update, :show, :search
    config.create.link.label = "Add Link"


  end
  def before_create_save(record)
    record.descendant_id = params[:associated_id]
  end
end
