class Testable < ActiveRecord::Base
  belongs_to :staff
  belongs_to :patient
  belongs_to :source
  belongs_to :department
  
  def to_label
    #{name}
  end
end
