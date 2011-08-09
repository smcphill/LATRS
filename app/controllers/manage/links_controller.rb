# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Manage::LinksController < ApplicationController
  layout "manage"
  active_scaffold :links do | config |
    config.label = "Sub-Tests"
    config.columns = :descendant, :ancestor
    config.columns[:ancestor].label = "Sub-test"
    config.columns[:ancestor].clear_link
    config.columns[:ancestor].form_ui = :select
    config.list.always_show_search = false
    config.list.pagination = false
    config.list.per_page = 1000
    config.actions.exclude :show, :search
    config.create.link.label = "Add Sub-test"
    config.update.link = false


  end
  def before_create_save(record)
    record.descendant_id = params[:associated_id]
  end
  
end
