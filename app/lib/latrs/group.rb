require File.dirname(__FILE__) + '/field.rb'
module Latrs
  # this is what a group of fields looks like
  # Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
  # Copyright:: Copyright (c) 2011 Steven McPhillips
  # License::   See +license+ in root directory for license details
  class LatrsGroup
    attr_reader :id, :name, :description, :fields, :is_default
    attr_accessor :field_counts, :offset
    @id
    @name
    @description
    @fields
    @is_default
    @field_counts
    @offset
    # creates all the fields held in this group
    def initialize(id, offset)
      group = Group.find(id)
      @is_default = group.is_default? || false
      @id = id
      @field_counts = 0;
      @offset = offset
      if (not group.is_default?)
        @name = group.name
        @description = group.description
      end
      @fields = Array.new
      group.fields.each do |f|
        @fields << Latrs::LatrsField.new(f.id, offset + @field_counts)
        @field_counts += @fields.last.field_count
      end
    end

  end
end
