module Manage::LinksHelper
  def link_ancestor_form_column(record, options)
    template = Template.find(record.ancestor_id)
    tests = template.descendants.collect{|x| x.descendant_id}
    tests << record.ancestor_id
    select_tag("ancestor-input", 
               options_from_collection_for_select(Template.all(:conditions => ["id NOT IN (?)", tests]),
                                                  :id, :name), options)
  end
end
