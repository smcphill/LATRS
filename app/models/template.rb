class Template < ActiveRecord::Base

  has_many :fields, :dependent => :destroy
  def to_label
    "#{name}"
  end
end
