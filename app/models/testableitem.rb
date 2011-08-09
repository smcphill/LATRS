# This is the model for the test-specific data as defined
# by the corresponding template.
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Testableitem < ActiveRecord::Base
  belongs_to :testable
  #  validates_numericality_of :value, :if => Proc.new {|i| i.datatype == "Numericfield" }
  #  validates_presence_of :value, :if => Proc.new {|i| not i.name.nil? or i.required }

  # normally we would use the above validation helpers, but I don't want to use
  # the column name as the field identifier, but rather the record "name" attribute
  validate do |item|    
    item.errors.add(:value, "\"#{item.name}\" can't be empty") if item.required == "true" and item.value.blank?
    next if item.value.blank?
    item.errors.add(:value, "\"#{item.name}\" must be a number") if not item.value.match(/\A[+-]?\d+\.?\d*\Z/) and item.datatype == "Numericfield"
  end
  
  # this is how we can check for mandatory fields
  @required
  attr_accessor :required

  def to_label
    #{name}
  end
  
  def typedValue
    return (datatype == "Numericfield") ? Integer.new(value) : String.new(value)
  end
end
