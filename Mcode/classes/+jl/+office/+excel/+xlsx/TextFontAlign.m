classdef TextFontAlign < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Auto(org.apache.poi.xssf.usermodel.TextFontAlign.AUTO)
    Baseline(org.apache.poi.xssf.usermodel.TextFontAlign.BASELINE)
    Bottom(org.apache.poi.xssf.usermodel.TextFontAlign.BOTTOM)
    Center(org.apache.poi.xssf.usermodel.TextFontAlign.CENTER)
    Top(org.apache.poi.xssf.usermodel.TextFontAlign.TOP)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextFontAlign.AUTO)
        out = jl.office.excel.xlsx.TextFontAlign.Auto;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextFontAlign.BASELINE)
        out = jl.office.excel.xlsx.TextFontAlign.Baseline;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextFontAlign.BOTTOM)
        out = jl.office.excel.xlsx.TextFontAlign.Bottom;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextFontAlign.CENTER)
        out = jl.office.excel.xlsx.TextFontAlign.Center;
      elseif jObj.equals(org.apache.poi.xssf.usermodel.TextFontAlign.TOP)
        out = jl.office.excel.xlsx.TextFontAlign.Top;
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
    
    function this = TextFontAlign(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.TextFontAlign');
      this.j = jObj;
    end
  
  end
  
end