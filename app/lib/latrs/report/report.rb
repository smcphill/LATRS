module Latrs
  module Report
    
    class Expr
    end
    
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

    class TimeExpr < Latrs::Report::AtomExpr
      def to_s
        "#{@field} #{@op} #{@value}"
      end
    end
    
  end
  
end

