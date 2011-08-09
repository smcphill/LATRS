require 'singleton'
# A bit like the FormManager, the ReportManager
# keeps track of inbuilt reports.
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class ReportManager
  include Singleton

  @reports
  attr_reader :reports
  
  def initialize
    @reports = Hash.new
    @reports['1'] = malaria_strain
  end


  def malaria_strain
    malaria = Hash.new
    malaria[:name] = "Malaria: mixed strain"
    numvalue = " AND #{DB_TNUMVALS_SEARCH} >= 4"
    malaria[:desc] = <<EOD
Report on the number of Malaria tests with more than one 'P' strain (including PF), where the PF RBC Infection is >= 4%
EOD
    malaria[:sql] = <<EOS
SELECT testables.* 
FROM testables INNER JOIN testableitems ON testableitems.testable_id = testables.id INNER JOIN testableitems as ti2 ON ti2.testable_id = testables.id AND ti2.id != testableitems.id
WHERE testableitems.name = "PF::RBC Infection"
AND (ti2.name = 'PO' or ti2.name = 'PM' or ti2.name = 'PV')
EOS
    malaria[:sql] += numvalue
    return malaria
  end

end
