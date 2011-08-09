# We +belong_to+ a #Field, thereby limiting the 
# values that can be applied to it.
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Limit < ActiveRecord::Base
  after_initialize :init
  validate :validate_field_type
  belongs_to :field

  def to_label
    "#{name}"
  end

  # NumericField fields can only have numeric limits. makes sense, no?
  def validate_field_type
    if field and field.class.name == 'Numericfield'
      errors.add(:name, 
                 "must be a number because the form \
                 field has a type of 'Number'") if !name.match(/\A[+-]?[\d+\.]+\Z/)
    end
  end
  
  private
  def init
    self.is_default ||= false
  end
end
