# Departments +has_many+ #Testable s, and are 
# uniquely defined by their name
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Department < ActiveRecord::Base
  validates_uniqueness_of :name, 
                          :message => ": names must be unique", 
                          :case_sensitive => false
  has_many :testables

  def to_label
    "#{name}"
  end
end
