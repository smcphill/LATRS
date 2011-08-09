# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Manage::NumericfieldsController < Manage::FieldsController
  layout "manage"
  def to_label
    "Number"
  end
end
