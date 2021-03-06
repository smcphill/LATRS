# Patients. Not much to say really; the registrion number +RN+ must be unique
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Patient < ActiveRecord::Base
  GENDER = %w(m f u)
  validates_inclusion_of :gender, :in => GENDER

  validates_uniqueness_of :rn,
                          :message => ": RNs must be unique",
                          :case_sensitive => false
  has_many :testables

  def to_label
    "#{name} (RN: #{rn})"
  end

  # take their birthdate and subtract it from today. Provide age in form
  # of X years, Y months, Z days
  def age
    s = ""
    if not birthdate.nil?
      now = Date.today()
      birth = birthdate
      years = now.year - birth.year
      months = now.month - birth.month
      days = now.day - birth.day
      if days < 0
        days += 30
        months -= 1
      end
      if months < 0
        months += 12
        years -= 1
      end
      s = "#{years} yrs, #{months} mths, #{days} days"
    end
    "#{s}"
  end
end
