classdef TextDirection < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Horizontal(org.apache.poi.xssf.usermodel.TextDirection.HORIZONTAL)
    Stacked(org.apache.poi.xssf.usermodel.TextDirection.STACKED)
    Vertical(org.apache.poi.xssf.usermodel.TextDirection.VERTICAL)
    Vertical270(org.apache.poi.xssf.usermodel.TextDirection.VERTICAL_270)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextDirection.HORIZONTAL)
        out = jl.office.excel.xlsx.TextDirection.Horizontal;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextDirection.STACKED)
        out = jl.office.excel.xlsx.TextDirection.Stacked;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextDirection.VERTICAL)
        out = jl.office.excel.xlsx.TextDirection.Vertical;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextDirection.VERTICAL_270)
        out = jl.office.excel.xlsx.TextDirection.Vertical270;
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
    
    function this = TextDirection(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.TextDirection');
      this.j = jObj;
    end
  
  end
  
end