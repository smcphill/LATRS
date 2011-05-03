class Source < ActiveRecord::Base
  validates_uniqueness_of :name, 
                          :message => ": names must be unique", 
                          :case_sensitive => false

  def to_label
    "#{name}"
  end
end
