class Link < ActiveRecord::Base
  belongs_to :ancestor, :class_name => "Template", :foreign_key => "descendant_id"
  belongs_to :descendant, :class_name => "Template", :foreign_key => "ancestor_id"
  def to_label
    child = Template.find(self.descendant_id)
    "#{child.name}"
  end
end
