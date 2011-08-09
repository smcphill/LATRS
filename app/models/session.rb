# Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
# Copyright:: Copyright (c) 2011 Steven McPhillips
# License::   See +license+ in root directory for license details
class Session < ActiveRecord::Base

  # invoke with: +./script/runner -e [development|test|production] "Session.sweep();"+
  # +time_ago+ can be [0-9][mhd], where m = minutes, h = hours and d = days.
  # this will determine how old a session has to be for it to be destroyed.
  # the default is 1 day. however, all sessions created more than a week ago will
  # always be destroyed
  def self.sweep(time_ago = nil)
    time = case time_ago
           when /^(\d+)m$/ then Time.now - $1.to_i.minute
           when /^(\d+)h$/ then Time.now - $1.to_i.hour
           when /^(\d+)d$/ then Time.now - $1.to_i.day
           else Time.now - 1.day
           end
    self.delete_all "updated_at < '#{time.to_s(:db)}' OR " +
      "created_at < '#{7.days.ago.to_s(:db)}'"
  end
end
