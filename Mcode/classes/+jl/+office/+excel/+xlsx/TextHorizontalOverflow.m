classdef TextHorizontalOverflow < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Clip(org.apache.poi.xssf.usermodel.TextHorizontalOverflow.CLIP)
    Overflow(org.apache.poi.xssf.usermodel.TextHorizontalOverflow.OVERFLOW)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextHorizontalOverflow.CLIP)
        out = jl.office.excel.xlsx.TextHorizontalOverflow.Clip;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextHorizontalOverflow.OVERFLOW)
        out = jl.office.excel.xlsx.TextHorizontalOverflow.Overflow;
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
    
    function this = TextHorizontalOverflow(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.TextHorizontalOverflow');
      this.j = jObj;
    end
  
  end
  
end