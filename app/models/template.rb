class Template < ActiveRecord::Base

  has_many :child_tests, :foreign_key=>"child_id",
  :class_name=>"Derivative",
  :dependent => :destroy
  has_many :children, :through=>:child_tests

  has_many :fields, :dependent => :destroy
  def to_label
    "#{name}"
  end
end
