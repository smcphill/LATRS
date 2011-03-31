class TestType < ActiveRecord::Base
  belongs_to :outcome_type
  belongs_to :test
  has_many :children, :class_name => "TestType",
  :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "TestType"
end
