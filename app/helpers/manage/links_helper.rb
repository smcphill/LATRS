module Manage::LinksHelper
  def link_ancestor_form_column(record, options)
    select_tag("ancestor-input", 
               options_from_collection_for_select(Template.all(:conditions => ["id != ?", record.ancestor_id]),
                                                  :id, :name), options)
  end
end
