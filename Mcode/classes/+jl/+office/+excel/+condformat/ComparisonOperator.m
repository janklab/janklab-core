classdef ComparisonOperator
  %COMPARISONOPERATOR Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    code (1,1) double
  end
  
  enumeration
    Between(org.apache.poi.ss.usermodel.ComparisonOperator.BETWEEN)
    Equal(org.apache.poi.ss.usermodel.ComparisonOperator.EQUAL)
    GE(org.apache.poi.ss.usermodel.ComparisonOperator.GE)
    GT(org.apache.poi.ss.usermodel.ComparisonOperator.GT)
    LE(org.apache.poi.ss.usermodel.ComparisonOperator.LE)
    LT(org.apache.poi.ss.usermodel.ComparisonOperator.LT)
    NoComparison(org.apache.poi.ss.usermodel.ComparisonOperator.NO_COMPARISON)
    NotBetween(org.apache.poi.ss.usermodel.ComparisonOperator.NOT_BETWEEN)
    NotEqual(org.apache.poi.ss.usermodel.ComparisonOperator.NOT_EQUAL)
  end
  
  methods (Static)
  
    function out = ofJava(jVal)
      if isempty(jVal)
        out = [];
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.BETWEEN
        out = jl.office.excel.condformat.ComparisonOperator.Between;
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.EQUAL
        out = jl.office.excel.condformat.ComparisonOperator.Equal;
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.GE
        out = jl.office.excel.condformat.ComparisonOperator.GE;
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.GT
        out = jl.office.excel.condformat.ComparisonOperator.GT;
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.LE
        out = jl.office.excel.condformat.ComparisonOperator.LE;
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.LT
        out = jl.office.excel.condformat.ComparisonOperator.LT;
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.NO_COMPARISON
        out = jl.office.excel.condformat.ComparisonOperator.NoComparison;
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.NOT_BETWEEN
        out = jl.office.excel.condformat.ComparisonOperator.NotBetween;
      elseif jVal == org.apache.poi.ss.usermodel.ComparisonOperator.NOT_EQUAL
        out = jl.office.excel.condformat.ComparisonOperator.NotEqual;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      out = this.code;
    end
    
  end
  
  methods (Access = private)
    
    function this = ComparisonOperator(jVal)
      this.code = jVal;
    end
    
  end
  
end

