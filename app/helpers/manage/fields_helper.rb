module Manage::FieldsHelper
  FIELD_TYPES = [["Text", "Stringfield"],["Number", "Numericfield"]]

  def field_type_form_column(record, input_name)
    select_tag("type-input", 
               options_for_select(FIELD_TYPES, record.type), :name => "record[type]" )
  end

  def field_type_column(record)
    if (record.type == "Numericfield")
      "Number"
    else
      "Generic"
    end
  end

  def field_limits_column(record)
    if record.limits.any?
      rec_limits = record.limits.first(10).collect {|lim|
        if lim.is_default?
          {"key" => lim.name, "label" => "<u>#{lim.name}</u>"}
        else
          {"key" => lim.name, "label" => lim.name}
        end
      }
      rec_limits.sort_by {|lim| lim['key']}.collect {|lim| lim['label']}.join('<br/> ')
    else
      active_scaffold_config.list.empty_field_text
    end
  end

  def field_children_column(record)
    if record.children.any?
      # should we bold the default option here?
      record.children.first(10).collect{|kid| kid.name}.sort().join('<br/> ')
    else
      active_scaffold_config.list.empty_field_text
    end
  end

  def field_par_hi_lim_form_column(record, input_name)
    select("record", "par_hi_lim", record.parent.limits.collect {|l| l.name }, {:include_blank => '--select--'})
  end

  def field_par_lo_lim_form_column(record, input_name)
    select("record", "par_hi_lim", record.parent.limits.collect {|l| l.name }, {:include_blank => '--select--'})
  end
end
