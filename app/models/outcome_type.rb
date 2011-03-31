class OutcomeType < ActiveRecord::Base
  belongs_to :outcome_limit
  belongs_to :test_outcome
  has_many :children, :class_name => "OutcomeType",
  :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "OutcomeType"
  has_many :test_types
end
