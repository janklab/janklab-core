classdef EscapementType

  properties
    code
  end
  
  enumeration
    None(org.apache.poi.ss.usermodel.FontFormatting.SS_NONE)
    Sub(org.apache.poi.ss.usermodel.FontFormatting.SUB)
    Super(org.apache.poi.ss.usermodel.FontFormatting.SUPER)
  end
  
  
  methods (Static)
    
    function out = ofJava(jVal)
      if jVal.equals(org.apache.poi.ss.usermodel.FontFormatting.SS_NONE)
        out = jl.office.excel.condformat.EscapementType.None;
      elseif jVal.equals(org.apache.poi.ss.usermodel.FontFormatting.SS_SUB)
        out = jl.office.excel.condformat.EscapementType.Sub;
      elseif jVal.equals(org.apache.poi.ss.usermodel.FontFormatting.SS_SUB)
        out = jl.office.excel.condformat.EscapementType.Super;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods (Access = private)
    
    function this = EscapementType(code)
      this.code = code;
    end
    
    function out = toJava(this)
      out = this.code;
    end
    
  end
  
end

