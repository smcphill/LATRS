class Limit < ActiveRecord::Base
  belongs_to :field

  def to_label
    "#{name}"
  end
end
