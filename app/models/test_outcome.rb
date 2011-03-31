class TestOutcome < ActiveRecord::Base
  has_many :tests
  has_many :outcome_types
end
