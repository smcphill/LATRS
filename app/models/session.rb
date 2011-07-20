class Session < ActiveRecord::Base

  # invoke with: ./script/runner -e development "Session.sweep();"
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
