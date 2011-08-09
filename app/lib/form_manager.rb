require 'singleton'
require File.dirname(__FILE__) + '/latrs/form.rb'
# This class manages which forms can be created; only 
# 'active' #Template s can be used for data entry, but 
# any of them can be previewed. Whenever a template is 
# saved, the FormManager creates a new copy of the 
# corresponding Latrs::LatrsForm
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
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
  
  def previewForm(id)
    return Latrs::LatrsForm.new(Integer(id))
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
