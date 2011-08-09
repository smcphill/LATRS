# provides the interface to build your own report. a lot of the heavy
# lifting is done by ActiveScaffold
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details

class Report::TestablesController < ApplicationController
  layout "report"

  active_scaffold :testables do | config |
    config.label = "Reports"
    config.list.pagination = true
    config.list.per_page = 5
    config.actions.exclude :create, :update, :delete
    config.actions = [:list, :show, :field_search]
    config.columns = [:time_in_str, :datatype, :department, :staff, :patient, :time_taken, :tnames, :tvals, :tnumvals]
    config.list.columns = [:time_in_str, :datatype, :department, :staff, :patient, :time_taken]
    config.show.columns.exclude :tnames, :twildnames, :tvals, :tnumvals

    
    #labels
    config.columns[:datatype].label = "Type"
    config.columns[:time_in_str].label = "Requested"
    config.columns[:tnames].label = "Test item name"
    config.columns[:tvals].label = "Test item value"
    config.columns[:tnumvals].label = "Test item value (numeric)"

    #search
    config.list.always_show_search = true
    config.field_search.columns = :datatype, :staff, :department, :time_in, :time_taken, :tnames, :tvals, :tnumvals

    config.columns[:datatype].search_ui = :select
    config.columns[:tnames].includes = [:testableitems]
    config.columns[:tnames].search_sql = "testableitems.name"
    config.columns[:tnames].options[:string_comparators] =  true
    config.columns[:tnames].search_ui = :select
    
    # this works on SqlLite only.
    config.columns[:time_taken].search_sql = DB_TIME_TAKEN_SEARCH
    config.columns[:time_taken].search_ui = :integer


    config.columns[:tvals].includes = [:testableitems]
    config.columns[:tvals].search_sql = "testableitems.value"
    config.columns[:tvals].options[:string_comparators] =  true
    config.columns[:tvals].search_ui = :string
    
    config.columns[:tnumvals].includes = [:testableitems]
    config.columns[:tnumvals].search_ui = :integer
    config.columns[:tnumvals].search_sql = DB_TNUMVALS_SEARCH
    
    #sort
    config.columns[:time_in_str].sort_by :sql => "time_in"
    config.columns[:time_taken].sort_by :sql => DB_TIME_TAKEN_SORT
  end
end
