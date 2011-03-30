class TestOutcome < ActiveRecord::Base
  belongs_to :test
  belongs_to :outcome_type
end
