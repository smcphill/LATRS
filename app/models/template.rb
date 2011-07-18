class Template < ActiveRecord::Base
  after_create :set_defaults
  after_update :set_activity
  validate :validate_active_status
  validates_uniqueness_of :name, 
                          :message => "Form names must be unique", 
                          :case_sensitive => false

  has_many :ancestors, :class_name => "Link", :foreign_key => "descendant_id"
  has_many :descendants, :class_name => "Link", :foreign_key => "ancestor_id"
  has_many :groups, :order => "position"
  has_many :fields, :through => :groups

  def to_label
    "#{name}"
  end

  # this will be our implemented type
  def rbName
    "#{self.name}^^#{self.id.to_s}"
  end

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
