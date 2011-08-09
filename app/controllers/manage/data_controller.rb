class Manage::DataController < ApplicationController
  layout "manage", :except => [:export, :do_export]

  require 'spreadsheet'
  require 'stringio'
  Spreadsheet.client_encoding = 'UTF-8'

  GENERAL_COLS = Array.new(['id',
                            'time_in',
                            'time_out',
                            'department.name',
                            'staff.name',
                            'patient.name',
                            'patient.rn',
                            'patient.age',
                            'patient.gender'
                            ]);

  PATIENT_COLS = Array.new(['id',
                            'rn',
                            'name',
                            'birthdate',
                            'gender',
                            'ethnicity',
                            'location']);

  TIME_STR = "%Y%m%d";

  def index
  end

  # export the last params[:days] worth of data, where time is taken
  # from midnight today. if no day is given, return all data
  def export
    start = Time.now.midnight
    if (not params[:all])
      time = case params[:type]
             when "days" then start - params[:time].to_i.day
             when "weeks" then start - (7 * params[:time].to_i).day
             else Time.at(0)
             end
    else
      time = Time.at(0)
    end
    book = Spreadsheet::Workbook.new
    test_names = Testable.all(:select => "DISTINCT(datatype)",
                              :conditions => ["time_in >= ? AND time_in <= ?", time, start]
                              ).collect {|t|t.datatype}
    test_names.each do |t|
      sheet = book.create_worksheet :name => t
      test_cols = Testableitem.all(:select => "DISTINCT(name), label",
                                   :order => :name,
                                   :joins => :testable,
                                   :conditions => {                                     
                                     :testables => {:datatype => t}
                                   }
                                   ).collect {|c|c.label.nil? ? [c.name] : [c.name,c.label]}
      write_header(sheet, 
                   GENERAL_COLS + test_cols.collect{|c|c[1].nil? ? c[0] : "#{c[0]} (#{c[1]})"})
      Testable.all(:conditions => ["datatype = ? AND time_in >= ? AND time_in <= ?", t, time, start], 
                   :include => :testableitems
                   ).each do |test|
        write_test(sheet, 
                   test, 
                   GENERAL_COLS, 
                   test_cols.collect{|c|c[0]})
      end
    end
    
    # and now, the patient registry
    patient_sheet = book.create_worksheet :name => "Patient Registry"
    write_header(patient_sheet, PATIENT_COLS)
    Patient.all().each do |patient|
      write_test(patient_sheet, patient, PATIENT_COLS)
    end
    
    data = StringIO.new
    book.write data
    filename = "latrs-#{time.strftime(TIME_STR)}-TO-#{start.strftime(TIME_STR)}"

    respond_to do |format|
      format.html { send_data data.string, :type=>"application/excel",
                                           :disposition=>'attachment',
                                           :filename => "#{filename}.xls"
      }
      format.xml { 
        render :xml => to_xml(book,time,start)
      }
    end

  end

  protected

  def to_xml(book,from,to)
    xml = Hash.new()
    xml['start-date'] = from
    xml['end-date'] = to
    xml['tests'] = Hash.new
    xml['patients'] = Hash.new
    book.worksheets.each do |s|
      if s.name.match('Patient')
        base = xml['patients']
        type = 'patient'
        record = 'patient'
      else
        base = xml['tests']
        type = s.name.gsub(/[\s\:\(\)\%\/\\]+/,'-')
        record = 'test'
      end

      header = s.rows[0].collect{|c|c.gsub(/[\s\:\(\)\%\/\\]+/,'-')}
      s.rows.each_with_index do |test,index|
        next if index == 0
        key = "#{record}-#{test[0].to_s}"
        base[key] = Hash.new
        base[key]['type'] = type
        test.each_with_index do |col,idx|
          base[key][header[idx]] = col if not col.blank?
        end
      end
    end
    return xml.to_xml({:root => 'Latrs'})
  end

  def header_nicename(header)
    header.to_s.gsub(/[_\.]+/,' ').gsub(/\b\w/, &:upcase)
  end

  def write_header(sheet, header, labels = nil)
    sheet.row(0).default_format = Spreadsheet::Format.new :weight => :bold,
                                                          :size => 14
    sheet.row(0).concat(header.collect {|h| header_nicename(h) })
  end

  def write_test(sheet, test, cols, test_cols = nil)
    row = sheet.row(sheet.last_row_index+1)
    cols.each do |col|
      cell = "test.#{col}"
      row.push(eval(cell)) rescue row.push("-")
    end
    if not test_cols.nil?
      test_cols.each do |col|
        value = test.testableitems.all(:conditions => {:name => col}).collect {|c| c.value}
        if value.length > 1
          row.push(value.collect{|v| '"%s"' % v}.join(', '))
        else
          row.push(value.first())
        end
      end
    end
  end
end
