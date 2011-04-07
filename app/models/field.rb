class Field < ActiveRecord::Base
  after_initialize :init

  has_many :limits, :dependent => :destroy
  has_one :children, :class_name => "Field", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "Field"
  belongs_to :template
  def to_label
    "#{name}"
  end

  private
  def init
    self.is_required ||= false
    self.is_general ||= false
    self.type ||= "Stringfield"
  end
end

