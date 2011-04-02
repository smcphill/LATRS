class Field < ActiveRecord::Base
  has_many :limits, :dependent => :destroy
  belongs_to :template

  def to_label
    "#{name}"
  end
end
