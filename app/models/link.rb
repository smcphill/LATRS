# This is how we do self-referential joins. The #Link is how #Template subtests are modeled
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Link < ActiveRecord::Base
  belongs_to :ancestor, :class_name => "Template", :foreign_key => "descendant_id"
  belongs_to :descendant, :class_name => "Template", :foreign_key => "ancestor_id"
  def to_label
    child = Template.find(self.descendant_id)
    "#{child.name}"
  end
end
