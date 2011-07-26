module Report::TestablesHelper
   def testable_tnames_search_column(record, html_options)
     items = Testableitem.all(:select => "distinct (name)", :order => "name")
     selected = params[:search][:tnames] if not params[:search].nil? and not params[:search][:tnames].nil?
     select_tag "search[tnames]",
                options_for_select([['- select -', '']] + items.collect {|i| [i.name, i.name] }, selected)                
   end
end
