# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Template < ActiveRecord::Base
  after_create :set_defaults
  after_update :set_activity
  validate :validate_active_status
  validates_presence_of :name,
                        :message => "You must provide a form name" 
  
  validates_uniqueness_of :name, 
                          :message => "Form names must be unique", 
                          :case_sensitive => false

  has_many :ancestors, :class_name => "Link", :foreign_key => "descendant_id"
  has_many :descendants, :class_name => "Link", :foreign_key => "ancestor_id"
  has_many :groups, :order => "position"
  has_many :fields, :through => :groups

  accepts_nested_attributes_for :groups

  def to_label
    "#{name}"
  end

  # templates can only be activated when data can be stored for it. 
  # this means templates with no fields cannot be activated
  def validate_active_status
    if (is_active and fields.count() == 0)
      errors.add(:fields, ": active forms require at least one data field.")
    end
  end

  private
  def set_defaults
    if self.is_active.nil?
      self.is_active = false
      self.save
    end
  end

  def set_activity
    if self.is_active?
      FormManager.instance.loadForm(self.id)
    else
      FormManager.instance.unloadForm(self.id)
    end
  end

end
