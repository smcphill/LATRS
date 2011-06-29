class Testableitem < ActiveRecord::Base
  belongs_to :testable
  belongs_to :field

  def to_label
    #{self.field.name}
  end

  def numberVal
    Integer(self.value)
  end
  
end
