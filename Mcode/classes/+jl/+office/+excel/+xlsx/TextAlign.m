classdef TextAlign < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Center(org.apache.poi.xssf.usermodel.TextAlign.CENTER)
    Dist(org.apache.poi.xssf.usermodel.TextAlign.DIST)
    Justify(org.apache.poi.xssf.usermodel.TextAlign.JUSTIFY)
    JustifyLow(org.apache.poi.xssf.usermodel.TextAlign.JUSTIFY_LOW)
    Left(org.apache.poi.xssf.usermodel.TextAlign.LEFT)
    Right(org.apache.poi.xssf.usermodel.TextAlign.RIGHT)
    ThaiDist(org.apache.poi.xssf.usermodel.TextAlign.THAI_DIST)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAlign.CENTER)
        out = jl.office.excel.xlsx.TextAlign.Center;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAlign.DIST)
        out = jl.office.excel.xlsx.TextAlign.Dist;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAlign.JUSTIFY)
        out = jl.office.excel.xlsx.TextAlign.Justify;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAlign.JUSTIFY_LOW)
        out = jl.office.excel.xlsx.TextAlign.JustifyLow;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAlign.LEFT)
        out = jl.office.excel.xlsx.TextAlign.Left;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAlign.RIGHT)
        out = jl.office.excel.xlsx.TextAlign.Right;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextAlign.THAI_DIST)
        out = jl.office.excel.xlsx.TextAlign.ThaiDist;
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
    
    function this = TextAlign(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.TextAlign');
      this.j = jObj;
    end
  
  end
  
end