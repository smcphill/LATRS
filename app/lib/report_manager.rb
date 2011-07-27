require 'singleton'
class ReportManager
  include Singleton

  @reports
  attr_accessor :reports
  
  def initialize
    @reports = Hash.new
  end

end
