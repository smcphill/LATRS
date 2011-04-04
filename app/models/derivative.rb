class Derivative < ActiveRecord::Base
  belongs_to :child, :class_name => "Template", :foreign_key => "child_id"
#  belongs_to :parent, :class_name => "Template", :foreign_key => "parent_id"
end
