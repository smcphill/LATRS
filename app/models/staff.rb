# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Staff < ActiveRecord::Base
  validates_uniqueness_of :name, 
                          :message => ": names must be unique", 
                          :case_sensitive => false
  has_many :testables

  def to_label
    "#{name}"
  end
end
