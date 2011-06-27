class Staff < ActiveRecord::Base
  validates_uniqueness_of :name, 
                          :message => ": names must be unique", 
                          :case_sensitive => false
  has_many :testables

  def to_label
    "#{name}"
  end
end
