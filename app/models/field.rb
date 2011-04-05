class Field < ActiveRecord::Base
  has_many :limits, :dependent => :destroy
  has_one :children, :class_name => "Field", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "Field"
  belongs_to :template
  def to_label
    "#{name}"
  end
end

