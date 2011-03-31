class Test < ActiveRecord::Base
  belongs_to :test_outcome
  has_many :children, :class_name => "Test",
  :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Test"
  has_many :departments
  has_many :testers
  has_many :patients
  has_many :sources
  has_many :test_types
end
