class Testableitem < ActiveRecord::Base
  belongs_to :testable
  belongs_to :field
end
