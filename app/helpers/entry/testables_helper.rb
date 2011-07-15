module Entry::TestablesHelper

  def belongs_widget(form, symbol, source)
    content_tag(:dt, form.label(symbol)) +
    content_tag(:dd, form.collection_select(symbol, source, :id, :name))
  end

  def time_widget(form, symbol)
    opts = {:time => "mixed",
      :minute_interval => 5,
      :year_range => 3.years.ago..1.years.from_now,
      :value => Time.new.strftime('%B %-d, %Y %-I:%M %p')}

    content_tag(:dt, form.label(symbol)) +
      content_tag(:dd, form.calendar_date_select(symbol, opts))
  end

  def field_label(field)
    content_tag(:label, :class => field_class(field)) do
      "#{field.name}"
    end
  end

  # use opts instead of these params
  def field_children(kids, type, builder, form, subtest)
    if kids.count > 0
      content_tag(:dl, :class => type) do
        s = ""
        kids.each do |k|
          s << render(:partial => "field", :locals => {:field => k, :builder => builder, :form => form, :subtest => subtest})
        end
        s
      end
    end
  end

  def field_input(field, builder)
    input = ""
    opts = Hash.new
    hopts = Hash.new
    if field.limits.count > 0
      # set up options: multi-select, include blank
      opts[:include_blank] = true if not field.is_required and not field.is_multi
      default_limit = field.limits.select {|l| l.is_default }.first
      opts[:selected] = default_limit.name if not default_limit.nil?
      hopts[:multiple] = true if field.is_multi
      input = builder.select(:value,
                     field.limits.collect {|l| [ l.name, l.name] }, 
                     opts,
                     hopts)
    else
      input = builder.text_field(:value, 
                                 :class => 'short')
    end
    input += builder.hidden_field(:name, :value => field.name)
    input += builder.hidden_field(:datatype, :value => field.type)
    input += builder.hidden_field(:label, :value => field.label)
    "#{input} #{field.label}"
  end

  def description_box(text)
    if not text.nil?
      content_tag(:div, text, :class=>'description')
    end
  end

  # some simple element attribute helpers

  def group_class(group)
    cssClass = "group"
    cssClass += " default" if group.is_default
    return "class='#{cssClass}'"
  end

  def field_class(field)
    return "required" if field.is_required
  end

  def limit_default(limit)
    return " selected " if limit.is_default
  end

  def multi_field(field)
    return " multiple " if field.is_multi
  end
end