class Report::TestablesController < ApplicationController
  layout "report"
  active_scaffold :testables do | config |
    config.label = "Reports"
    config.list.pagination = true
    config.list.per_page = 5
    config.actions.exclude :create, :update, :delete
    config.actions = [:list, :show, :field_search]
    config.list.always_show_search = true
    config.columns = [:time_in_str, :datatype, :department, :source, :staff, :patient, :time_taken, :tnames, :twildnames, :tvals, :tnumvals]
    config.list.columns = [:time_in_str, :datatype, :department, :source, :staff, :patient, :time_taken]
    config.show.columns.exclude :tnames, :twildnames, :tvals

    
    #labels
    config.columns[:datatype].label = "Type"
    config.columns[:time_in_str].label = "Requested"
    config.columns[:tnames].label = "Test item name"
    config.columns[:twildnames].label = "Test item name (alt)"
    config.columns[:tvals].label = "Test item value"
    config.columns[:tnumvals].label = "Test item value (numeric)"

    #search
    config.list.always_show_search = true
    config.field_search.columns = :datatype, :staff, :department, :source, :time_in, :time_taken, :tnames, :twildnames, :tvals, :tnumvals
    config.columns[:datatype].search_ui = :select
    config.columns[:tnames].includes = [:testableitems]
    config.columns[:tnames].search_sql = "testableitems.name"
    config.columns[:tnames].options[:string_comparators] =  true
    config.columns[:tnames].search_ui = :select

    config.columns[:twildnames].includes = [:testableitems]
    config.columns[:twildnames].search_sql = "testableitems.name"
    config.columns[:twildnames].options[:null_comparators] =  false
    config.columns[:twildnames].options[:string_comparators] =  true
    config.columns[:twildnames].search_ui = :string
    
    # this works on SqlLite only.
    config.columns[:time_taken].search_sql = "(strftime('%s',time_out) - strftime('%s',time_in)) / 60"
    config.columns[:time_taken].search_ui = :integer
    # this works on MySQL only.
    #config.columns[:time_taken].search_sql = "TIMESTAMPDIFF(MINUTE,time_in,time_out)"
    #this works on MS SQL only. - untested
    #config.columns[:time_taken].search_sql = "DATEDIFF ( minute , time_in , time_out )"
    


    config.columns[:tvals].includes = [:testableitems]
    config.columns[:tvals].search_sql = "testableitems.value"
    config.columns[:tvals].options[:string_comparators] =  true
    config.columns[:tvals].search_ui = :string
    
    config.columns[:tnumvals].includes = [:testableitems]
    # this works in SqlLite only
    config.columns[:tnumvals].search_sql = "round(testableitems.value, 2)"
    # this works in MySQL only
    #config.columns[:tnumvals].search_sql = "format(testableitems.value, 2)"
    # this works in MS SQL only - untested
    #config.columns[:tnumvals].search_sql = "round(cast(testableitems.value AS FLOAT),2)"

    config.columns[:tnumvals].search_ui = :integer
    


    #sort
    config.columns[:time_in_str].sort_by :sql => "time_in"
  end
end
