class TestType < ActiveRecord::Base
  has_many :outcome_types
  has_many :tests
  has_many :children, :class_name => "TestType",
  :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "TestType"
end
