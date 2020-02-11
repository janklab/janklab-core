classdef TextAutoFit < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    None(org.apache.poi.xssf.usermodel.TextAutoFit.NONE)
    Normal(org.apache.poi.xssf.usermodel.TextAutoFit.NORMAL)
    Shape(org.apache.poi.xssf.usermodel.TextAutoFit.SHAPE)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAutoFit.NONE)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAutoFit.NORMAL)
        out = jl.office.excel.xlsx.TextAutofit.Normal;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAutoFit.SHAPE)
        out = jl.office.excel.xlsx.TextAutofit.Shape;
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
    
    function this = TextAutoFit(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.TextAutoFit');
      this.j = jObj;
    end
  
  end
  
end