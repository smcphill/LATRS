class Template < ActiveRecord::Base
  has_many :ancestors, :class_name => "Link", :foreign_key => "descendant_id"
  has_many :descendants, :class_name => "Link", :foreign_key => "ancestor_id"
  has_many :fields, :dependent => :destroy
  def to_label
    "#{name}"
  end
end
