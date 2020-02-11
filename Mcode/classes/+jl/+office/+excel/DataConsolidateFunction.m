classdef DataConsolidateFunction < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Average(org.apache.poi.ss.usermodel.DataConsolidateFunction.AVERAGE)
    Count(org.apache.poi.ss.usermodel.DataConsolidateFunction.COUNT)
    CountNums(org.apache.poi.ss.usermodel.DataConsolidateFunction.COUNT_NUMS)
    Max(org.apache.poi.ss.usermodel.DataConsolidateFunction.MAX)
    Min(org.apache.poi.ss.usermodel.DataConsolidateFunction.MIN)
    Product(org.apache.poi.ss.usermodel.DataConsolidateFunction.PRODUCT)
    StdDev(org.apache.poi.ss.usermodel.DataConsolidateFunction.STD_DEV)
    StdDevP(org.apache.poi.ss.usermodel.DataConsolidateFunction.STD_DEVP)
    Sum(org.apache.poi.ss.usermodel.DataConsolidateFunction.SUM)
    Var(org.apache.poi.ss.usermodel.DataConsolidateFunction.VAR)
    VarP(org.apache.poi.ss.usermodel.DataConsolidateFunction.VARP)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.AVERAGE)
        out = jl.office.excel.DataConsolidateFunction.Average;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.COUNT)
        out = jl.office.excel.DataConsolidateFunction.Count;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.COUNT_NUMS)
        out = jl.office.excel.DataConsolidateFunction.CountNums;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.MAX)
        out = jl.office.excel.DataConsolidateFunction.Max;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.MIN)
        out = jl.office.excel.DataConsolidateFunction.Min;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.PRODUCT)
        out = jl.office.excel.DataConsolidateFunction.Product;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.STD_DEV)
        out = jl.office.excel.DataConsolidateFunction.StdDev;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.STD_DEVP)
        out = jl.office.excel.DataConsolidateFunction.StdDevP;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.SUM)
        out = jl.office.excel.DataConsolidateFunction.Sum;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.VAR)
        out = jl.office.excel.DataConsolidateFunction.Var;
      elseif jObj.equals(org.apache.poi.ss.usermodel.DataConsolidateFunction.VARP)
        out = jl.office.excel.DataConsolidateFunction.VarP;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      out = this.j;
    end
    
  end
  
  methods (Access = private)
    
    function this = DataConsolidateFunction(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.DataConsolidateFunction');
      this.j = jObj;
    end
  
  end
  
end