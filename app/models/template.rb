class Template < ActiveRecord::Base
  has_many :fields

  def to_label
    "#{name}"
  end
end
