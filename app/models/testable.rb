class Testable < ActiveRecord::Base
  belongs_to :staff
  belongs_to :patient
  belongs_to :source
  belongs_to :department
  has_many :testableitems, :dependent => :destroy
  has_many :subtests, :class_name => "Testable", :foreign_key => "linked_test_id"
  belongs_to :master, :class_name => "Testable"

  @saveme
  attr_accessor :saveme

  # we won't store testableitems that don't have a value
  accepts_nested_attributes_for :testableitems, :reject_if => proc { |attr| attr['value'].blank? }
  # we won't store subtests that don't have any testableitem values at all
  accepts_nested_attributes_for :subtests, :reject_if => :check_subtest

  def check_subtest(obj)
    obj['saveme'] == 'false' or 
      obj['testableitems_attributes'].nil? or  
      obj['testableitems_attributes'].values.reject {|x| x['value'].blank? }.empty?
  end

  def to_label
    #{name}
  end

end
