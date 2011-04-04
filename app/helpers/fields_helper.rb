module FieldsHelper
  def field_limits_column(record)
    if record.limits.any?
      # should we bold the default option here?
      record.limits.first(10).collect{|limit| limit.name}.sort().join(', ')
    else
      active_scaffold_config.list.empty_field_text
    end
  end

end
