require File.dirname(__FILE__) + '/field.rb'
module Latrs
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
