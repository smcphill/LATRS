require 'net/http'
require 'uri'
require 'xml'
class HealthInfoController < ApplicationController
  layout false
  @@rn_url = HIS_RN_URL


  # construct a nice list of patient RNs
  # note that we won't always have a patient record
  # for all patients we list. this means when one is
  # attached to a test, we might need to create a
  # record on the fly
  def list
    begin
      doc = healthinfo_doc()
      @patients = Array.new
      doc.find('patient').to_a.each do |p|
        patient = Hash.new
        rn = p.find_first('RN')
        name = p.find_first('PtName')
        if rn and name
          patient[:rn] = rn.content
          patient[:name] = name.content
          @patients.push(patient)
        end
      end          
      if @patients.empty?
        redirect_to :action => "auto_complete_for_patient_rn", :controller => "entry/testables", :pid => params[:id]
        logger.debug "No matching patients from HIS HealthInfo"
        return
      end
    rescue
      redirect_to :action => "auto_complete_for_patient_rn", :controller => "entry/testables", :pid => params[:id]
      logger.warn "Could not connect to HIS HealthInfo service"
    end
  end

  def migrate
    begin
      doc = healthinfo_doc()
      pnode = doc.find_first("patient[RN='#{params[:id]}']")
      if pnode.nil?
        logger.warn "Could not migrate patient from HIS HealthInfo"
        render :status => 200, :text => 'Could not migrate patient from HIS HealthInfo'
        return
      end
      rn = pnode.find_first('RN').content
      @patient = Patient.find_or_initialize_by_rn(rn)
      pnode.children.each do |f|
        case f.name
        when "PtName"
          @patient.name = f.content
        when "gender"
          @patient.gender = f.content
        when "Ethnicity"
          @patient.ethnicity = f.content
        when "district"
          @patient.location = f.content
        when "DateofBirth"
          @patient.birthdate = Date.strptime(f.content,
                                             HIS_DATE_FORMAT)
        end
      end
      if @patient.save
        logger.debug "migrated user #{rn} from HIS HealthInfo"
        logger.debug "our patient object: #{@patient.inspect}" if not @patient.nil?
      else
        logger.warn "Could not migrate patient from HIS HealthInfo"
        logger.debug "our patient object: #{@patient.inspect}" if not @patient.nil?
        render :status => 200, :text => 'Could not migrate patient from HIS HealthInfo'
        return
      end
    rescue
      logger.debug "our patient object: #{@patient.inspect}" if not @patient.nil?
      logger.warn "Could not connect to HIS HealthInfo"
      render :status => 200, :text => 'Could not connect to HIS HealthInfo'
      return
    end
    head :ok
  end

private
  def healthinfo_doc
    Net::HTTP.version_1_2
    url = URI.parse(@@rn_url + params[:id])
    request = Net::HTTP.new(url.host, url.port)
    request.open_timeout = 2
    request.read_timeout = 5
    begin
      request.start
    rescue Exception
      return nil
    else
      response = request.get(url.path).body
      request.finish    
      doc = XML::Parser.string(response).parse() 
      return doc
    end
  end
end
