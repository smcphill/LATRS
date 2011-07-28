require 'singleton'
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
    malaria[:desc] = <<EOD
Report on the number of Malaria tests with more than one 'P' strain (including PF), where the PF RBC Infection is >= 4%
EOD
    malaria[:sql] = <<EOS
SELECT testables.* 
FROM testables INNER JOIN testableitems as ti ON ti.testable_id = testables.id INNER JOIN testableitems as ti2 ON ti2.testable_id = testables.id AND ti2.id != ti.id
WHERE ti.name = "PF::RBC Infection"
AND (ti2.name = 'PO' or ti2.name = 'PM' or ti2.name = 'PV')
AND round(ti.value,2) >= 4
EOS

    return malaria
  end

end
