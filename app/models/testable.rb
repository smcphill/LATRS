# This is the model for our test results.
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Testable < ActiveRecord::Base
  belongs_to :staff
  belongs_to :patient
  belongs_to :department
  has_many :testableitems, :dependent => :destroy
  has_many :subtests, :class_name => "Testable", :foreign_key => "linked_test_id"
  belongs_to :master, :class_name => "Testable", :foreign_key => "linked_test_id"

  # VALIDATIONS
  validates_associated :testableitems
  validates_associated :subtests
  validates_presence_of :department_id
  validates_presence_of :staff_id
  
  # NESTED ATTRIBUTES
  accepts_nested_attributes_for :testableitems
  # we won't store subtests that don't have any testableitem values at all
  accepts_nested_attributes_for :subtests, :reject_if => Proc.new {|s| s['saveme'] == 'false' }

  # helper for subtests
  @saveme
  @pos
  attr_accessor :saveme, :pos

  def to_label
    #{datatype}
  end

  # all the data stored in this test
  def tvals
    testableitems.collect {|t| t.value }
  end

  # all the data stored in this test, to be 
  # played with numerically
  def tnumvals
    testableitems.collect {|t| t.value }
  end

  # name of all the data stored in this test
  def tnames
    testableitems.collect {|t| t.name }
  end

  # pretty format of +time_in+ 
  def time_in_str
    "#{time_in.strftime(FULLTIME).gsub(/ 0(\d\D)/, ' \1')}"
  end

  # pretty format of +time_out+ 
  def time_out_str
    "#{time_out.strftime(FULLTIME).gsub(/ 0(\d\D)/, ' \1')}"
  end

  # how long did this test take to process. +time_out - time_in+
  # outputs something like 'X hours, Y minutes, Z seconds'
  def time_taken
    time_spent = time_out.to_datetime - time_in.to_datetime
    hours, minutes, seconds, fracs = Date.day_fraction_to_time(time_spent.to_f)
    "#{hours} hours, #{minutes} minutes, #{seconds} seconds"
  end

  # when we reject empty subtests, we lose them from the array which sucks;
  # the order of subtests within the form and us needs to be sync'd...
  def add_lost_subtests(subs)
    # first off, make sure we have enough subtests
    while (subs.length > self.subtests.length) do
      self.subtests.build
    end
    newsubs = Array.new(subs.length,nil)

    #now, find a workable sort ordering
    self.subtests.each_with_index do |sub, index|
      if sub.datatype.nil?
        pos = newsubs.index {|s| s.nil?}        
      else
        pos = subs.index {|s| s.name == sub.datatype}
      end
      newsubs[pos] = true
      sub[:pos] = pos
    end
    
    #and do the sort
    self.subtests.sort! {|a,b| a[:pos] <=> b[:pos]}

    #finally, build the testableitems for our empty subtests
    # have a look at your new controller method... some of this stuff is repeated and should live in the model
    self.subtests.each_with_index do |sub, index |
      item_count = subs[index].nbr_fields - sub.testableitems.length
      item_count.times {sub.testableitems.build}
    end
  end
end
