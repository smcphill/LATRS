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
    else
      conds = Latrs::Search::Parser.new(report_params)
      tests = Testable.all(:conditions => "#{conds.parse}", :joins => :testableitems)
      test_ids = Testable.all(:select => "DISTINCT (testables.id)", :conditions => "#{conds.parse}", :joins => :testableitems).collect {|t|t.id}
      @report_data = Hash.new
      @report_data[:tests] = test_ids.count

      @report_data[:patients] = Hash.new
                                                       
      @report_data[:patients][:ethnicity] = Array.new
      @report_data[:patients][:gender] = Array.new
      @report_data[:patients][:gender][0] = Hash.new
      @report_data[:patients][:gender][1] = Hash.new
      @report_data[:patients][:age] = Array.new
      @report_data[:patients][:age][0] = Hash.new
      @report_data[:patients][:age][1] = Hash.new
      @report_data[:patients][:age][2] = Hash.new
      @report_data[:patients][:age][3] = Hash.new
      @report_data[:patients][:age][4] = Hash.new
      @report_data[:patients][:age][5] = Hash.new
      @report_data[:patients][:age][6] = Hash.new
      @report_data[:patients][:age][7] = Hash.new

      

      @report_data[:patients][:gender][0][:male] = 0
      @report_data[:patients][:gender][1][:female] = 0
      @report_data[:patients][:age][0]['unknown'] = 0
      @report_data[:patients][:age][1]['under 10'] = 0
      @report_data[:patients][:age][2]['10 - 20'] = 0
      @report_data[:patients][:age][3]['20 - 30'] = 0
      @report_data[:patients][:age][4]['30 - 40'] = 0
      @report_data[:patients][:age][5]['40 - 50'] = 0
      @report_data[:patients][:age][6]['50 - 60'] = 0
      @report_data[:patients][:age][7]['over 60'] = 0

      patient_ids = Testable.all(:select => "patient_id", :conditions => ["id in (?)", test_ids]).collect {|p|p.patient_id}
      Patient.all(:select => "strftime('%Y','now') - strftime('%Y', birthdate) as years, gender, ethnicity", :conditions => ["id in (?)", patient_ids]).each_with_index do |p,i|
        @report_data[:patients][:ethnicity][i] = Hash.new
        @report_data[:patients][:ethnicity][i][p.ethnicity] = 0 if not @report_data[:patients][:ethnicity][i].has_key?(p.ethnicity)

        @report_data[:patients][:ethnicity][i][p.ethnicity] += 1
        @report_data[:patients][:gender][0][:male] += 1 if p.gender == 'm'
        @report_data[:patients][:gender][1][:female] += 1 if p.gender == 'f'
        if p.years.nil?
          @report_data[:patients][:age][0]['unknown'] += 1
        elsif p.years.to_i < 10
          @report_data[:patients][:age][1]['under 10'] += 1
        elsif p.years.to_i < 20
          @report_data[:patients][:age][2]['10 - 20'] += 1
        elsif p.years.to_i < 30
          @report_data[:patients][:age][3]['20 - 30'] += 1
        elsif p.years.to_i < 40
          @report_data[:patients][:age][4]['30 - 40'] += 1
        elsif p.years.to_i < 50
          @report_data[:patients][:age][5]['40 - 50'] += 1
        elsif p.years.to_i < 60
          @report_data[:patients][:age][6]['50 - 60'] += 1
        else
          @report_data[:patients][:age][7]['over 60'] += 1
        end
      end

      @report_data[:depts] = Array.new
      dept_ids = Testable.all(:select => "department_id", :conditions => ["id in (?)", test_ids]).collect {|s|s.department_id}
      Department.all(:select => "distinct (name), id", :order => :name, :conditions => ["id in (?)", dept_ids]).each_with_index do |d,i|
        @report_data[:depts][i] = Hash.new
        @report_data[:depts][i][d.name] = Testable.count(:conditions => ["department_id = ? AND id IN (?)",
                                                                      d.id,
                                                                      test_ids])
      end

      @report_data[:staff] = Array.new
      staff_ids = Testable.all(:select => "staff_id", :conditions => ["id in (?)", test_ids]).collect {|s|s.staff_id}
      Staff.all(:select => "distinct (name), id", :order => :name, :conditions => ["id in (?)",staff_ids]).each_with_index do |s,i|
        @report_data[:staff][i] = Hash.new
        @report_data[:staff][i][s.name] = Testable.count(:conditions => ["staff_id = ? AND id IN (?)",
                                                                      s.id,
                                                                      test_ids])
      end

      @report_data[:fields] = Array.new
      @report_data[:rule] = "#{conds.parse}"
      
      fields = Testableitem.find_by_sql("select distinct t1.name, t1.datatype from testableitems t1 where t1.testable_id in (#{tests.collect{|t| t.id}.join(', ')})")

      fields.sort {|a,b| a.name <=> b.name}.each_with_index do |field,i|
        @report_data[:fields][i] = Hash.new if @report_data[:fields][i].nil?
        @report_data[:fields][i][field.name] = Hash.new

        if field.datatype == 'Numericfield'
          min = Testableitem.minimum("round(value,2)",
                                     :conditions => ["testable_id IN (?) AND name = ?",
                                                     test_ids, field.name])
          max = Testableitem.maximum("round(value,2)",
                                     :conditions => ["testable_id IN (?) AND name = ?",
                                                     test_ids, field.name])
          range = max - min
          step = range / 20
          curr = min;
          count = 0
          while curr <= max
            @report_data[:fields][i][field.name]["#{curr} - #{curr + step}"] = Hash.new
            @report_data[:fields][i][field.name]["#{curr} - #{curr + step}"][:pos] = count
            @report_data[:fields][i][field.name]["#{curr} - #{curr + step}"][:val]= 0;
            curr += step
            count += 1
          end
          Testableitem.all(:select => "value", 
                       :conditions => ["name = ? AND testable_id IN (?)",
                                       field.name, test_ids]).each do |val|
            # find out which slot this val belongs to
            @report_data[:fields][i][field.name].each_pair do |key,value|
              (min, max) = key.to_s.match(/(\d+\.?\d*)\s-\s(\d+\.?\d*)/)[1..2]
              min = min.to_f
              max = max.to_f
              if val.value.to_f >= min and val.value.to_f < max
                @report_data[:fields][i][field.name][key][:val] += 1
                break
              end
            end
          end
        else
          Testableitem.all(:select => "value", 
                           :conditions => ["name = ? AND testable_id IN (?)",
                                           field.name, test_ids]).each_with_index do |val,j|
            @report_data[:fields][i][field.name][val.value] = Hash.new if not @report_data[:fields][i][field.name].has_key?(val.value)
            @report_data[:fields][i][field.name][val.value][:pos] = j
            @report_data[:fields][i][field.name][val.value][:val] = 0 if not @report_data[:fields][i][field.name][val.value].has_key?(:val)
            @report_data[:fields][i][field.name][val.value][:val] += 1
          end
        end
      end

      render :layout => "raw-report"
    end
  end

end
