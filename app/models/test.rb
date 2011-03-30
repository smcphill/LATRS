class Test < ActiveRecord::Base
  has_many :test_outcomes
  has_many :children, :class_name => "Test",
  :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Test"
  belongs_to :department
  belongs_to :tester
  belongs_to :patient
  belongs_to :source
  belongs_to :test_type
end
