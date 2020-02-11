classdef TextCap < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    All(org.apache.poi.xssf.usermodel.TextCap.ALL)
    None(org.apache.poi.xssf.usermodel.TextCap.NONE)
    Small(org.apache.poi.xssf.usermodel.TextCap.SMALL)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextCap.ALL)
        out = jl.office.excel.xlsx.TextCap.All;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextCap.NONE)
        out = jl.office.excel.xlsx.TextCap.None;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextCap.SMALL)
        out = jl.office.excel.xlsx.TextCap.Small;
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
    
    function this = TextCap(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.TextCap');
      this.j = jObj;
    end
  
  end
  
end