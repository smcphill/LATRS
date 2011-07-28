module Latrs  
  module Search
    # parse the fielded search to get our report struct
    class Parser
      @args
      def initialize(args)
        # now strip out the useless stuff:
        #  - (key[:from].blank? and key[:to].blank?)  if kind_of?(Hash)
        #  - value.blank?
        args.delete_if {|key,val| val.empty? }
        args.delete_if {|key,val| val.kind_of?(Hash) and (val[:from].nil? or val[:from].empty?) and (val[:to].nil? or val[:to].empty?) }
        @args = args
      end
      
      def parse
        exprs = Array.new
        has_tnames = @args.has_key?(:tnames)
        @args.each_pair do |key,val|
          # we have a few special conditions here:
          #  - time_in is a hash, with datetimes
          #  - time_taken is the difference between time_in and time_out, in minutes
          #  - staff and department are joins on staff.id, department.id to [table].name
          #  - tnames is the 'name' part for either tvals or tnumvals, or just on its own
          #  - tvals is the "value" part of a field.
          #  - tnumvals is like tvals, but only has numbers
          
          expr = nil
          case key.to_s
          when "time_in"
            if not val[:from].empty? and not val[:to].empty?
              e1 = Latrs::Report::AtomExpr.new(key, val[:from], '>=')
              e2 = Latrs::Report::AtomExpr.new(key, val[:to], '<=')
              expr = Latrs::Report::ClauseExpr.new(['AND'], e1, e2)
            elsif not val[:from].empty?
              expr = Latrs::Report::AtomExpr.new(key, val[:from], '>=')
            elsif not val[:to].empty?
              expr = Latrs::Report::AtomExpr.new(key, val[:to], '<=')
            end
          when "time_taken"
            tkey = "(strftime('%s',time_out) - strftime('%s',time_in)) / 60"
            if not val[:from].empty? and not val[:to].empty?
              e1 = Latrs::Report::TimeExpr.new(tkey, val[:from], val[:opt])
              e2 = Latrs::Report::TimeExpr.new(tkey, val[:to], val[:opt])
              expr = Latrs::Report::ClauseExpr.new(['AND'], [e1, e2])
            elsif not val[:from].empty?
              expr = Latrs::Report::TimeExpr.new(tkey, val[:from], val[:opt])
            elsif not val[:to].empty?
              expr = Latrs::Report::TimeExpr.new(tkey, val[:to], val[:opt])
            end
          when "tnames"
            # do we have any values?
            # if tvals and tnumvals both missing, we're on our own
            # elsif tvals, check to and from
            # else, check tnumvals (to and from)
            if not @args.has_key?(:tvals) and not @args.has_key?(:tnumvals)
              expr = Latrs::Report::AtomExpr.new("testableitems.name", val, "like")
            elsif @args.has_key?(:tvals)
              # check to and from. if both, we'll have 3 exprs
              e1 = Latrs::Report::AtomExpr.new("testableitems.name", val, "like")
              es = make_exprs('testableitems.value', @args[:tvals])
              es = [e1] + es if not e1.nil?
            else
              # we have tnumvals. check to and from. if both, we'll have 3 exprs
              e1 = Latrs::Report::AtomExpr.new("testableitems.name", val, "like")
              es = make_exprs('round(testableitems.value,2)', @args[:tnumvals])
              es = [e1] + es if not e1.nil?
            end
            if expr.nil?
              ops = Array.new
              es.reject {|e| e.nil?}
              (es.count - 1).times { ops.push('AND') }
              expr = Latrs::Report::ClauseExpr.new(ops, es)
            end
          when "tvals", "tnumvals"
            # if we have a field name, we can do nothing
            tkey = "testableitems.value"
            tkey = "round(#{tkey},2)" if key.to_s == "tnumvals"
            if not has_tnames
              es = make_exprs(tkey, val)
              if not es.nil?
                es.reject {|e| e.nil?}
                if not es.nil?
                  if es.count == 1
                    expr = es
                  else
                    ops = Array.new
                    (es.count - 1).times { ops.push('AND') }
                    expr = Latrs::Report::ClauseExpr.new(ops, es)
                  end
                end
              end
            end
          when "staff", "department"
            expr = Latrs::Report::AtomExpr.new("#{key}_id", val, '=')
          when "datatype"
            expr = Latrs::Report::AtomExpr.new("testables.#{key}", val, '=')
          end
          exprs.push(expr) if not expr.nil?
        end
        if (exprs.count > 1)
          ops = Array.new
          (exprs.count - 1).times { ops.push("AND") }
          return Latrs::Report::ClauseExpr.new(ops, exprs).to_s
        else
          return exprs[0].to_s
        end
      end
      
      def make_name(name, val, op)
        opt = parse_opt(op, val)
        if opt.kind_of?(Array)
          op = opt[0]
          val = opt[1]
          return Latrs::Report::AtomExpr.new(name, val, op)
        else
          return nil
        end
      end
      
      def make_exprs(name,val)
        exprs = Array.new
        if not val[:to].nil? and not val[:to].empty? and not val[:from].nil? and not val[:from].empty?
          if val[:opt] == "BETWEEN"
            e1 = make_name(name, val[:from], val[:opt])
            e2 = make_name(name, val[:to], val[:opt])
            exprs.push(Latrs::Report::ClauseExpr.new(['AND'], [e1, e2]))
          else
            e = make_name(name, val[:from], val[:opt])
            exprs.push(e) if not e.nil?
            e = make_name(name, val[:to], val[:opt])
            exprs.push(e) if not e.nil?
          end
        elsif not val[:to].nil? and not val[:to].empty?
          e = make_name(name, val[:to], val[:opt])
          exprs.push(e) if not e.nil?
        else
          e = make_name(name, val[:from], val[:opt])
          exprs.push(e) if not e.nil?
        end
        return exprs
      end
      
      def parse_opt(op, val)
        val = val.to_s
        op = op.to_s
        case op
        when "%?%"
          op = "like"
          val = "%#{val}%"
        when "?%"
          op = "like"
          val = "#{val}%"
        when "%?"
          op = "like"
          val = "%#{val}"
        when "BETWEEN"
          return false
        end
        return [op, val]
      end
    end
  end
end

