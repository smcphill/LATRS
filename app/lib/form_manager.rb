require 'singleton'
require File.dirname(__FILE__) + '/latrs/form.rb'
class FormManager
  include Singleton
  
  def initialize
    @forms = Hash.new()
    Template.all(:conditions => { :is_active => true }).each do |t|
      loadForm(t.id)
    end    
  end

  def hasForm(id)
    id = Integer(id)
    return @forms.has_key?(id)
  end

  def activeForms
    return @forms.keys
  end

  def getForm(id)
    id = Integer(id)
    reloadForm(id)
    return @forms[id]
  end

  def loadForm(id)
    id = Integer(id)
    t = Template.find(id)
    if ((not @forms.has_key?(id)) and t.is_active?) 
      @forms[id] = Latrs::LatrsForm.new(id)
    end
  end
  
  def unloadForm(id)
    id = Integer(id)
    if (@forms.has_key?(id))
      @forms.delete(id)
    end
  end

  def reloadForm(id)
    id = Integer(id)
    unloadForm(id)
    loadForm(id)
  end
end
