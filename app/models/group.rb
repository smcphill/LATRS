class Group < ActiveRecord::Base
  belongs_to :template
  has_many :fields, :source => :field, :order => "position"

  def to_label
    "#{name}"
  end

  def authorized_for_update? 
    return !self.is_default?
  end 

  def authorized_for_delete?
    return !self.is_default?
  end

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
