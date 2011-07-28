class ReportController < ApplicationController
  layout "report", :except => :custom

  def index
#    @templates = Template.all(:conditions => ["id IN (?)",
#                                              FormManager.instance.activeForms])
  end

  # this is a pretty big job; need to set up a bunch of data
  # hashes to display the report. code probably belongs somewhere else...
  def custom
    scaf_sess = session['as:report/testables']

    if  scaf_sess.nil?
      redirect_to :action => 'index' 
      return
    end

    report_params = scaf_sess[:search]
    if not report_params.has_key?(:datatype) or report_params[:datatype].blank?
      flash[:error] = "Please select a test type"
      redirect_to :action => 'index', :controller => '/report/testables'
      return
    else
      conds = Latrs::Search::Parser.new(report_params)
      tests = Testable.all(:conditions => "#{conds.parse}", :joins => :testableitems)
      if tests.count < 1
        flash[:error] = "No matching tests found"
        redirect_to :action => 'index', :controller => '/report/testables'
        return
      end

      @report_data = generate_report(tests)      
      @report_data[:rule] = "#{conds.parse}"

      render :layout => "raw-report"
    end
  end

  def generate_report(tests)
    test_ids = tests.collect{|t|t.id}.uniq

    report = Hash.new
    report[:tests] = test_ids.count

    report[:patients] = Hash.new
    
    report[:patients][:ethnicity] = Array.new
    report[:patients][:gender] = Array.new
    report[:patients][:gender][0] = Hash.new
    report[:patients][:gender][1] = Hash.new
    report[:patients][:age] = Array.new
    report[:patients][:age][0] = Hash.new
    report[:patients][:age][1] = Hash.new
    report[:patients][:age][2] = Hash.new
    report[:patients][:age][3] = Hash.new
    report[:patients][:age][4] = Hash.new
    report[:patients][:age][5] = Hash.new
    report[:patients][:age][6] = Hash.new
    report[:patients][:age][7] = Hash.new

    

    report[:patients][:gender][0][:male] = 0
    report[:patients][:gender][1][:female] = 0
    report[:patients][:age][0]['unknown'] = 0
    report[:patients][:age][1]['under 10'] = 0
    report[:patients][:age][2]['10 - 20'] = 0
    report[:patients][:age][3]['20 - 30'] = 0
    report[:patients][:age][4]['30 - 40'] = 0
    report[:patients][:age][5]['40 - 50'] = 0
    report[:patients][:age][6]['50 - 60'] = 0
    report[:patients][:age][7]['over 60'] = 0

    patient_ids = Testable.all(:select => "patient_id", :conditions => ["id in (?)", test_ids]).collect {|p|p.patient_id}
    Patient.all(:select => "strftime('%Y','now') - strftime('%Y', birthdate) as years, gender, ethnicity", :conditions => ["id in (?)", patient_ids]).each_with_index do |p,i|
      report[:patients][:ethnicity][i] = Hash.new
      report[:patients][:ethnicity][i][p.ethnicity] = 0 if not report[:patients][:ethnicity][i].has_key?(p.ethnicity)

      report[:patients][:ethnicity][i][p.ethnicity] += 1
      report[:patients][:gender][0][:male] += 1 if p.gender == 'm'
      report[:patients][:gender][1][:female] += 1 if p.gender == 'f'
      if p.years.nil?
        report[:patients][:age][0]['unknown'] += 1
      elsif p.years.to_i < 10
        report[:patients][:age][1]['under 10'] += 1
      elsif p.years.to_i < 20
        report[:patients][:age][2]['10 - 20'] += 1
      elsif p.years.to_i < 30
        report[:patients][:age][3]['20 - 30'] += 1
      elsif p.years.to_i < 40
        report[:patients][:age][4]['30 - 40'] += 1
      elsif p.years.to_i < 50
        report[:patients][:age][5]['40 - 50'] += 1
      elsif p.years.to_i < 60
        report[:patients][:age][6]['50 - 60'] += 1
      else
        report[:patients][:age][7]['over 60'] += 1
      end
    end

    report[:depts] = Array.new
    dept_ids = Testable.all(:select => "department_id", :conditions => ["id in (?)", test_ids]).collect {|s|s.department_id}
    Department.all(:select => "distinct (name), id", :order => :name, :conditions => ["id in (?)", dept_ids]).each_with_index do |d,i|
      report[:depts][i] = Hash.new
      report[:depts][i][d.name] = Testable.count(:conditions => ["department_id = ? AND id IN (?)",
                                                                       d.id,
                                                                       test_ids])
    end

    report[:staff] = Array.new
    staff_ids = Testable.all(:select => "staff_id", :conditions => ["id in (?)", test_ids]).collect {|s|s.staff_id}
    Staff.all(:select => "distinct (name), id", :order => :name, :conditions => ["id in (?)",staff_ids]).each_with_index do |s,i|
      report[:staff][i] = Hash.new
      report[:staff][i][s.name] = Testable.count(:conditions => ["staff_id = ? AND id IN (?)",
                                                                       s.id,
                                                                       test_ids])
    end

    report[:fields] = Array.new
    
    fields = tests.collect {|t| t.testableitems}.flatten
    field_ids = fields.collect { |f|f.id}.uniq
    fields = fields.collect {|f|f.name}.uniq
    fields.sort {|a,b| a <=> b}.each_with_index do |name,i|
      report[:fields][i] = Hash.new if report[:fields][i].nil?
      report[:fields][i][name] = Hash.new
      
      Testableitem.all(:select => "value", 
                       :conditions => ["name = ? AND id in (?) AND testable_id IN (?)",
                                       name, field_ids, test_ids]).each_with_index do |val,j|
        report[:fields][i][name][val.value] = Hash.new if not report[:fields][i][name].has_key?(val.value)
        report[:fields][i][name][val.value][:pos] = j
        report[:fields][i][name][val.value][:val] = 0 if not report[:fields][i][name][val.value].has_key?(:val)
        report[:fields][i][name][val.value][:val] += 1
      end
    end
    
    return report
  end
  
end
