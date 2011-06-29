require 'singleton'
class FormManager
  include Singleton
  attr_reader :forms
  
  def initialize
    @forms = Hash.new()
    Template.all(:conditions => { :is_active => false }).each do |t|
      loadForm(t.id)
    end    
  end

  def loadForm(id)
    if (not @forms.has_key?(id)) 
      t = Template.find(id)
      Object.const_set(t.rbName, Class.new(Testable))
      @forms.store(id, t.rbName)
    end
  end
  
  def unloadForm(id)
    if (@forms.has_key?(id))
      className = @forms[id]
      @forms.delete(id)
      begin
        Object.send(:remove_const, className)
      rescue NameError
        # couldn't find the thing... oh well
      end        
    end
  end
end
