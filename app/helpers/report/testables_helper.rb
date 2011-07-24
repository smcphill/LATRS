module Report::TestablesHelper
   def tnames_search_column(record, html_options)
     logger.debug "our params: #{params.inspect}"
     items = Testableitem.all(:select => "distinct (name)", :order => "name")
     selected = params[:search][:tnames] if not params[:search].nil? and not params[:search][:tnames].nil?
     select_tag "search[tnames][from]",
     options_for_select ([''] +items.collect {|i| [i.name, i.name] }, selected),
       html_options
   end
end
