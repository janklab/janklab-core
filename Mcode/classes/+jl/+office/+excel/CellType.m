classdef CellType
  
  enumeration
    None, Blank, Boolean, Error, Formula, Numeric, String, Unknown
  end
  
  methods (Static)
    
    function out = ofJava(j)
      if j.equals(org.apache.poi.ss.usermodel.CellType.BLANK)
        out = jl.office.excel.CellType.Blank;
      elseif j.equals(org.apache.poi.ss.usermodel.CellType.BOOLEAN)
        out = jl.office.excel.CellType.Boolean;
      elseif j.equals(org.apache.poi.ss.usermodel.CellType.ERROR)
        out = jl.office.excel.CellType.Error;
      elseif j.equals(org.apache.poi.ss.usermodel.CellType.FORMULA)
        out = jl.office.excel.CellType.Formula;
      elseif j.equals(org.apache.poi.ss.usermodel.CellType.NUMERIC)
        out = jl.office.excel.CellType.Numeric;
      elseif j.equals(org.apache.poi.ss.usermodel.CellType.STRING)
        out = jl.office.excel.CellType.String;
      else
        out = jl.office.excel.CellType.Unknown;
      end
    end
    
  end
  
end