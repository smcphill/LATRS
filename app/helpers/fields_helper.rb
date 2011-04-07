module FieldsHelper
  FIELD_TYPES = [["Generic", "Stringfield"],["Number", "Numericfield"]]

  def type_form_column(record, input_name)
    select_tag("type-input", 
               options_for_select(FIELD_TYPES, record.type), :name => "record[type]" )
  end

  def type_column(record)
    if (record.type == "Numericfield")
      "Number"
    else
      "Generic"
    end
  end

  def is_general_form_column(record, input_name)
    select_tag input_name, options_for_select({"True" => "true", "False" => "false"},
                                              record.is_general || "false")
  end

  def is_required_form_column(record, input_name)
    select_tag input_name, options_for_select({"True" => "true", "False" => "false"},
                                              record.is_required || "false")
  end

  def field_limits_column(record)
    if record.limits.any?
      # should we bold the default option here?
      record.limits.first(10).collect{|limit| limit.name}.sort().join(', ')
    else
      active_scaffold_config.list.empty_field_text
    end
  end

end
