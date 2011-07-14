require File.dirname(__FILE__) + '/group.rb'
module Latrs
  class LatrsForm
    attr_reader :id, :colour, :name, :description, :groups, :subtests, :parent, :className

    @id
    @colour
    @name
    @description
    @groups
    @subtests
    @parent
    @className

    def initialize(id, parent_form = nil)
      template = Template.find(id)
      @className = template.rbName
      if (parent_form)
        @parent = parent_form
      end
      @id = id
      @colour = template.colour || "fff"
      @name = template.name
      @description = template.description

      @groups = Array.new
      offset = 0;
      template.groups.each do |g|
        @groups << Latrs::LatrsGroup.new(g.id, offset)
        offset += groups.last.field_counts
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

    def nbr_fields
      count = 0
      @groups.each do |g|
        count += g.field_counts
      end
      return count
    end

  end
end
