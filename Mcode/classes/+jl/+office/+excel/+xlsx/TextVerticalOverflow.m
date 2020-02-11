classdef TextVerticalOverflow < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Clip(org.apache.poi.xssf.usermodel.TextVerticalOverflow.CLIP)
    Ellipsis(org.apache.poi.xssf.usermodel.TextVerticalOverflow.ELLIPSIS)
    Overflow(org.apache.poi.xssf.usermodel.TextVerticalOverflow.OVERFLOW)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextVerticalOverflow.CLIP)
        out = jl.office.excel.xlsx.TextVerticalOverflow.Clip;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextVerticalOverflow.ELLIPSIS)
        out = jl.office.excel.xlsx.TextVerticalOverflow.Ellipsis;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextVerticalOverflow.OVERFLOW)
        out = jl.office.excel.xlsx.TextVerticalOverflow.Overflow;
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
    
    function this = TextVerticalOverflow(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.TextVerticalOverflow');
      this.j = jObj;
    end
  
  end
  
end