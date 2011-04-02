class Limit < ActiveRecord::Base
  belongs_to :field, :class_name => "Field", :foreign_key => "field_id"

  def to_label
    "#{name}"
  end
end
