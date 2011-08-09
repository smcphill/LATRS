module Latrs
  # our home-grown reporting module. this is an attempt
  # to build a manageable query structure around SQL
  # that can be easily parsed / walked. This makes
  # going from a pseudo natural language to a 
  # specific set of rules much easier
  # Author::    Steven McPhillips  (mailto:steven.mcphillips@gmail.com)
  # Copyright:: Copyright (c) 2011 Steven McPhillips
  # License::   See +license+ in root directory for license details
  module Report
    
    # 'abstract' superclass. only there so we can
    # say all sort of expressions are the same
    class Expr
    end
    
    # corresponds to a +WHERE+ clause in +SQL+
    class ClauseExpr < Latrs::Report::Expr
      @ops
      @exprs
      attr_reader :ops, :exprs
      # ops can be either AND, OR, AND NOT, or OR NOT
      
      def initialize(ops, exprs)
        @ops = ops
        @exprs = exprs
      end

      def to_s
        value = ''
        @exprs.each_with_index do |e,i|
          value += "#{e.to_s}"
          value += " #{@ops[i]} " if not @ops[i].nil?
        end

        return '(%s)' % value
      end
    end
    
    # corresponds to a comparitor used in an +SQL WHERE+ clause
    # eg: "name = 'Steven'", or "patient_id is null".
    class AtomExpr < Latrs::Report::Expr
      @field
      @value
      @op
      attr_accessor :field, :value, :op

      def initialize(field, value, op)
        @field = field
        @value = value
        @op = op
      end

      # provides the sql
      def to_s
        if not @value.empty?
          if @value.match(/\A[+-]?\d+\.?\d*\Z/).nil?
            @value = "'#{@value}'" 
          end
          return "#{@field} #{@op} #{@value}"            
        else
          return "#{@field} #{@op}"
        end
      end
    end
    
    # a helper class to deal with datetimes - 
    # we don't really want to play around with
    # the value, field or operator with these
    class TimeExpr < Latrs::Report::AtomExpr
      def to_s
        "#{@field} #{@op} #{@value}"
      end
    end
    
  end
  
end

