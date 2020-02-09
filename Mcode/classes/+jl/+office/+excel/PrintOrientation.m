classdef PrintOrientation
  %PRINTORIENTATION 
  
  properties
    j
  end
  
  enumeration
    Default(org.apache.poi.ss.usermodel.PrintOrientation.DEFAULT)
    Landscape(org.apache.poi.ss.usermodel.PrintOrientation.LANDSCAPE)
    Portrait(org.apache.poi.ss.usermodel.PrintOrientation.PORTRAIT)
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.PrintOrientation.DEFAULT)
        out = jl.office.excel.PrintOrientation.Default;
      elseif jObj.equals(org.apache.poi.ss.usermodel.PrintOrientation.LANDSCAPE)
        out = jl.office.excel.PrintOrientation.Landscape;
      elseif jObj.equals(org.apache.poi.ss.usermodel.PrintOrientation.PORTRAIT)
        out = jl.office.excel.PrintOrientation.Portrait;
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
    
    function this = PrintOrientation(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.PrintOrientation');
      this.j = jObj;
    end
    
  end
  
end

