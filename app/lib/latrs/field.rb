require File.dirname(__FILE__) + '/limit.rb'
module Latrs
  class LatrsField
    attr_reader :name, :position, :label, :children, :is_required, :parent, :min, :max, :display, :is_multi, :limits, :type, :inlineChildren, :blockChildren
    attr_accessor :field_count, :offset
    @name
    @position
    @label
    @children
    @is_required
    @type
    # subfield-specific
    @parent
    @min
    @max
    @display
    #type-specific
    @is_multi
    @limits
    # misc
    @field_count
    @offset

    @inlineChildren
    @blockChildren

    def initialize(id, offset, parent_field = nil)
      field = Field.find(id)

      if (parent_field)
        @parent = parent_field
        @min = field.par_lo_lim
        @max = field.par_hi_lim
        @display = field.display_as || "i"
      end

      @offset = offset
      @field_count = 1;
      @name = field.name
      @position = field.position
      @label = field.unit_label
      @is_required = field.is_required || false
      @is_multi = field.is_multi || false
      @type = field.type || "Stringfield"

      @limits = Array.new
      field.limits.each do |l|
        @limits << Latrs::LatrsLimit.new(l.id, self)
      end

      @children = Array.new
      field.children.each do |c|
        situ_offset = offset + @field_count
        @children << Latrs::LatrsField.new(c.id, 
                                           situ_offset,
                                           self)
        @field_count += @children.last.field_count
      end

      @inlineChildren = @children.select {|c| c.display == "i" }.compact
      @blockChildren = @children.select {|c| c.display == "l" }.compact
    end

  end
end
