class OutcomeType < ActiveRecord::Base
  has_many :outcome_limits
  has_many :test_outcomes
  has_many :children, :class_name => "OutcomeType",
  :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "OutcomeType"
  belongs_to :test_type
end
