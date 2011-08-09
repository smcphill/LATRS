module Latrs
  # this is what a selectable field limit looks like
  # Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
  # Copyright:: Copyright (c) 2011 Steven McPhillips
  # License::   See +license+ in root directory for license details
  class LatrsLimit
    attr_reader :is_default, :name, :field, :position
    @is_default
    @name
    @field
    @position
    
    def initialize(id, parent_field)
      limit = Limit.find(id)
      @field = parent_field
      @name = limit.name
      @is_default = limit.is_default || false
      @position = limit.position || limit.id
    end
  end
end
