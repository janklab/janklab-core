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
        out = jl.office.excel.cf.ComparisonOperator.Between;
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

