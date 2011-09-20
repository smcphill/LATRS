# We +belong_to+ a #Template, and +has_many+ #Field s
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Group < ActiveRecord::Base
  belongs_to :template
  has_many :fields, :source => :field, :order => "position"

  accepts_nested_attributes_for :fields, :allow_destroy => true

  def to_label
    "#{name}"
  end

  # the default group cannot be edited
  def authorized_for_update? 
    return !self.is_default?
  end 

  # the default group cannot be deleted
  def authorized_for_delete?
    return !self.is_default?
  end

  # the default group is the one called +"_default"+
  def is_default?
    return self.name == '_default'
  end

  # when we delete a group, relocate all fields to the default group
  def before_destroy
    default = Group.find(:first, 
                         :conditions => ["template_id = ? and name = '_default'", 
                                         self.template_id])
    if (default.is_default?)
      self.fields.each do |f|
        f.group_id = default.id
        f.save
      end
      #trigger a save to (hopefully) refresh the data for AS
      default.save
    end
  end
end
