classdef FontFamily
  
  enumeration
    Decorative
    Modern
    NotApplicable
    Roman
    Script
    Swiss
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.FontFamily.DECORATIVE)
        out = jl.office.excel.FontFamily.Decorative;
      elseif jObj.equals(org.apache.poi.ss.usermodel.FontFamily.MODERN)
        out = jl.office.excel.FontFamily.Modern;
      elseif jObj.equals(org.apache.poi.ss.usermodel.FontFamily.NOT_APPLICABLE)
        out = jl.office.excel.FontFamily.NotApplicable;
      elseif jObj.equals(org.apache.poi.ss.usermodel.FontFamily.ROMAN)
        out = jl.office.excel.FontFamily.Roman;
      elseif jObj.equals(org.apache.poi.ss.usermodel.FontFamily.SCRIPT)
        out = jl.office.excel.FontFamily.Script;
      elseif jObj.equals(org.apache.poi.ss.usermodel.FontFamily.SWISS)
        out = jl.office.excel.FontFamily.Swiss;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      if this == jl.office.excel.FontFamily.Decorative
        out = org.apache.poi.ss.usermodel.FontFamily.DECORATIVE;
      elseif this == jl.office.excel.FontFamily.Modern
        out = org.apache.poi.ss.usermodel.FontFamily.MODERN;
      elseif this == jl.office.excel.FontFamily.NotApplicable
        out = org.apache.poi.ss.usermodel.FontFamily.NOT_APPLICABLE;
      elseif this == jl.office.excel.FontFamily.Roman
        out = org.apache.poi.ss.usermodel.FontFamily.ROMAN;
      elseif this == jl.office.excel.FontFamily.Script
        out = org.apache.poi.ss.usermodel.FontFamily.SCRIPT;
      elseif this == jl.office.excel.FontFamily.Swiss
        out = org.apache.poi.ss.usermodel.FontFamily.SWISS;
      else
        BADSWITCH
      end
    end
    
  end
end