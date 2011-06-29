class Testable < ActiveRecord::Base
  belongs_to :staff
  belongs_to :patient
  belongs_to :source
  belongs_to :department
  
  def to_label
    #{name}
  end

  # c.f http://code.alexreisner.com/articles/single-table-inheritance-in-rails.html
  def self.inherited(child)
    child.instance_eval do
      def model_name
        Testable.model_name
      end
    end
    super
  end
  
  @child_classes = []
  
  # c.f http://code.alexreisner.com/articles/single-table-inheritance-in-rails.html
  def self.inherited(child)
    @child_classes << child
    super # important!
  end
  
  def self.child_classes
    @child_classes
  end
end
