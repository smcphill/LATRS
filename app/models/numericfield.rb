# A #Field that is used to store numbers. We should probably make more use
# of this fact for the #ReportController, but this information is kind of 
# lost in #Entry::TestablesController creation.
# There is also a #Stringfield for text
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Numericfield < Field
  def to_label
    "#{name}"
  end
end
