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

  # AS fielded search options
  def testable_datatype_search_column(record, input_name)
    select :record, :datatype, Testable.all(:select => "DISTINCT(datatype)").collect {|t| [t.datatype.split('^^').first(), t.datatype]}, {:include_blank => as_('- select -')}, input_name
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
      id = input.match(/id="(.+?)"/)[0][4..-2]
      hash_var = id + "s"
      hash_vals = field.limits.collect {|l| "'#{l.name}':'#{l.position}'" }
      input += javascript_tag do
        "var #{hash_var} = new Hash({#{hash_vals.join(',')}});\n" +
          "$('#{id}').observe('change', function(event,obj) {caller = this;displayChildren(event,obj,caller);});\n" + 
          "function hidefields#{field.object_id.to_s.gsub(/-/,'_')}() {Event.simulate($('#{id}'), 'change');}";
      end
    else      
      input = builder.text_field(:value, 
                                 :class => 'short')
      input += javascript_tag do
        "function hidefields#{field.object_id.to_s.gsub(/-/,'_')}() {}";
      end
    end
    input += builder.hidden_field(:name, :value => field.dbName)
    input += builder.hidden_field(:datatype, :value => field.type)
    input += builder.hidden_field(:required, :value => field.is_required.to_s)
    input += builder.hidden_field(:max, :value => field.max, :disabled => true) if not field.max.nil?
    input += builder.hidden_field(:min, :value => field.min, :disabled => true) if not field.min.nil?
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
