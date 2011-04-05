class Limit < ActiveRecord::Base
  validate :validate_field_type
  belongs_to :field

  def to_label
    "#{name}"
  end

  def validate_field_type
    if field and field.class.name == 'Numericfield'
      errors.add(:name, 
                 "must be a number because the form \
                 field has a type of 'Number'") if !name.match (/\A[+-]?\d+\Z/)
    end
  end
end
