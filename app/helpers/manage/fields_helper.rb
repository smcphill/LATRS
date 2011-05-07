module Manage::FieldsHelper
  FIELD_TYPES = [["Text", "Stringfield"],["Number", "Numericfield"]]

  def field_type_form_column(record, input_name)
    select_tag("type-input", 
               options_for_select(FIELD_TYPES, record.type), :name => "record[type]" )
  end

  def field_name_column(record)
    if record.is_required?
      "<font color='red'>#{record.name}</font>"
    else
      "#{record.name}"
    end
  end

  def field_limits_column(record)
    if record.limits.any?
      rec_limits = record.limits.first(10).collect {|lim|
        if lim.is_default?
          {"key" => lim.name, "label" => "<u><b>#{lim.name}</b></u>"}
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
      "<ul class='children'>" + record.children.collect{|kid| 
        if kid.is_required?
          "<li><font color='red'>#{kid.name}</font></li>"
        else
          "<li>#{kid.name}</li>"
        end
        }.join('') + "</ul>"
    else
      active_scaffold_config.list.empty_field_text
    end
  end

  def field_par_hi_lim_form_column(record, input_name)
    if record.parent_id? && record.parent.limits.any?
      select("record", "par_hi_lim", record.parent.limits.collect {|l| l.name }, {:include_blank => '--select--'})
    else
      active_scaffold_config.list.empty_field_text
    end
  end

  def field_par_lo_lim_form_column(record, input_name)
    if record.parent_id? && record.parent.limits.any?
      select("record", "par_hi_lim", record.parent.limits.collect {|l| l.name }, {:include_blank => '--select--'})
    else
      active_scaffold_config.list.empty_field_text
    end
  end
end
