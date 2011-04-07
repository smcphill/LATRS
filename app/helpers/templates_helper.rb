module TemplatesHelper
  def is_active_form_column(record, input_name)
    select_tag input_name, options_for_select({"True" => "true", "False" => "false"},
                                              record.is_active || "false")
  end

end
