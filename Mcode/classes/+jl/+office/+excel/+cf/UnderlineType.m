classdef UnderlineType

  properties
    code
  end
  
  enumeration
    Double(org.apache.poi.ss.usermodel.FontFormatting.U_DOUBLE)
    DoubleAccounting(org.apache.poi.ss.usermodel.FontFormatting.U_DOUBLE_ACCOUNTING)
    None(org.apache.poi.ss.usermodel.FontFormatting.U_NONE)
    Single(org.apache.poi.ss.usermodel.FontFormatting.U_SINGLE)
    SingleAccounting(org.apache.poi.ss.usermodel.FontFormatting.U_SINGLE_ACCOUNTING)
  end
  
  
  methods (Static)
    
    function out = ofJava(jVal)
      if jVal.equals(org.apache.poi.ss.usermodel.FontFormatting.U_DOUBLE)
        out = jl.office.excel.cf.UnderlineType.Double;
      elseif jVal.equals(org.apache.poi.ss.usermodel.FontFormatting.U_DOUBLE_ACCOUNTING)
        out = jl.office.excel.cf.UnderlineType.DoubleAccounting;
      elseif jVal.equals(org.apache.poi.ss.usermodel.FontFormatting.U_NONE)
        out = jl.office.excel.cf.UnderlineType.None;
      elseif jVal.equals(org.apache.poi.ss.usermodel.FontFormatting.U_SINGLE)
        out = jl.office.excel.cf.UnderlineType.Single;
      elseif jVal.equals(org.apache.poi.ss.usermodel.FontFormatting.U_SINGLE_ACCOUNTING)
        out = jl.office.excel.cf.UnderlineType.SingleAccounting;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods (Access = private)
    
    function this = UnderlineType(code)
      this.code = code;
    end
    
    function out = toJava(this)
      out = this.code;
    end
    
  end
  
end

