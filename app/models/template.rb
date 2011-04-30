class Template < ActiveRecord::Base
  after_initialize :init
  validate :validate_active_status
  validates_uniqueness_of :name, 
                          :message => "Form names must be unique", 
                          :case_sensitive => false

  has_many :ancestors, :class_name => "Link", :foreign_key => "descendant_id"
  has_many :descendants, :class_name => "Link", :foreign_key => "ancestor_id"
  has_many :fields, :dependent => :destroy

  def to_label
    "#{name}"
  end

  def validate_active_status
    if (is_active and fields.count() == 0)
      errors.add(:fields, ": active forms require at least one data field.")
    end
  end

end
