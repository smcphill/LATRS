class Patient < ActiveRecord::Base
  validates_uniqueness_of :name, 
                          :message => ": names must be unique", 
                          :case_sensitive => false
  validates_uniqueness_of :rn, 
                          :message => ": RNs must be unique", 
                          :case_sensitive => false
  has_many :testables

  def to_label
    "#{name}"
  end
end
