require File.dirname(__FILE__) + '/group.rb'
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
module Latrs
  # encapsulates our template
  # Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
  # Copyright:: Copyright (c) 2011 Steven McPhillips
  # License::   See +license+ in root directory for license details
  class LatrsForm
    attr_reader :id, :colour, :name, :groups, :subtests, :nbr_fields
    attr_accessor :description

    @id
    @colour
    @name
    @description
    @groups
    @subtests
    @nbr_fields

    # creates all the bits that make a form;
    # field groups, subtests etc
    def initialize(id, parent_form = nil)
      template = Template.find(id)
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
