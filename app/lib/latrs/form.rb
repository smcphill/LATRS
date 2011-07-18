require File.dirname(__FILE__) + '/group.rb'
module Latrs
  class LatrsForm
    attr_reader :id, :colour, :name, :description, :groups, :subtests, :className, :nbr_fields

    @id
    @colour
    @name
    @description
    @groups
    @subtests
    @className
    @nbr_fields

    def initialize(id, parent_form = nil)
      template = Template.find(id)
      @className = template.rbName
      @id = id
      @colour = template.colour || "fff"
      @name = template.name
      @description = template.description

      @groups = Array.new
      offset = 0;
      @nbr_fields = 0;
      template.groups.each do |g|
        @groups << Latrs::LatrsGroup.new(g.id, offset)
        offset += groups.last.field_counts
        @nbr_fields += groups.last.field_counts
      end

      @subtests = Array.new
      # we only do subforms one level deep
      if (@parent.nil?)
        template.descendants.each do |d|
          subtest = Template.find(d.descendant_id)
          if (subtest.is_active?)
            @subtests << Latrs::LatrsForm.new(subtest.id, self)
          end
        end
      end
    end

  end
end
