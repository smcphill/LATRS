# A form Field belongs to a #Group or a parent #Field if it is a subfield
# It can have children #Field s as well, and #Limit s
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Field < ActiveRecord::Base
  DISP = %w(i l)

  after_initialize :init

  has_many :limits, :dependent => :destroy, :order => "position"
  has_many :children, :class_name => "Field", :foreign_key => "parent_id", :dependent => :destroy, :order => "position"
  belongs_to :parent, :class_name => "Field", :foreign_key => "parent_id"
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"

  accepts_nested_attributes_for :limits, :allow_destroy => true
  accepts_nested_attributes_for :children, :allow_destroy => true

  def to_label
    "#{name}"
  end
  
  # Creating fields can be time consuming. This is a deep copy
  # routine to take the pain out of things. The only difference
  # will be the resulting +field_id+, and the name (which will have 
  # "(copy)" appended to it
  def deep_copy(src)
    field = Field.find(src)
    name = field.name
    if (name !~ /\(copy\)\s*$/)
      name += " (copy)"
    end
    self.name = field.parent_id ? field.name : name
    self.group_id = field.group_id
    self.parent_id = field.parent_id
    self.is_required = field.is_required
    self.is_multi = field.is_multi
    self.type = field.type
    self.par_hi_lim = field.par_hi_lim
    self.par_lo_lim = field.par_lo_lim
    self.display_as = field.display_as
    self.save
    field.limits.each do |l|
      newL = l.clone :except => :field_id
      newL.field_id = self.id
      newL.save
    end
    field.children.each do |k|
      newK = Field.new
      newK.deep_copy(k.id)
      newK.parent_id = self.id
      newK.save
    end
    return self.id
  end

  # we use this to determine if a field can be moved into 
  # another group. returns true if there is more than one group
  # (ie another one to move to), *and* we aren't a subfield
  def authorized_for_move?
    if (self.group_id?)
      return (Group.count(:conditions => ["template_id = ?", 
                                         self.group.template_id]) > 1 &&
              !self.parent_id?)
    else
      return false
    end
  end

  private
  def init
    self.is_required ||= false
    self.is_multi ||= false
  end
end

