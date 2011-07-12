class Testableitem < ActiveRecord::Base
  belongs_to :testable

  def to_label
    #{name}
  end

  # need to make this work somehow...
  # def value
  #   if (type == "NumericItem")
  #     return Integer(self.value)
  #   else
  #     return self.value
  #   end
  # end
  
end
