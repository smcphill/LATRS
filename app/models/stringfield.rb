# A #Field that is used to store text. We should probably make more use
# of this fact for the #ReportController, but this information is kind of 
# lost in #Entry::TestablesController creation.
# There is also a #Numericfield for numbers
# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Stringfield < Field
  def to_label
    "#{name}"
  end
end
