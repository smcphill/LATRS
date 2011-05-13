class Field < ActiveRecord::Base
  DISP_OPTS = %w(i l)

  after_initialize :init

  has_many :limits, :dependent => :destroy
  has_many :children, :class_name => "Field", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "Field", :foreign_key => "parent_id"
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"

  def to_label
    "#{name}"
  end
  
  def deep_copy(src)
    field = Field.find(src)
    name = field.name
    if (name =~ /\(\#(\d+)\)\s*$/)
      num = Integer($1) + Integer(1)
      name.gsub!(/\(\#\d+\)\s*$/, "(##{num})")
    else
      name += " (#2)"
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
    self.created_at = Time.now
    self.updated_at = Time.now
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

