module LimitsHelper

  def is_default_form_column(record, input_name)
    select_tag input_name, options_for_select({"True" => "true", "False" => "false"},
                                              record.is_default || "false")
  end

end
