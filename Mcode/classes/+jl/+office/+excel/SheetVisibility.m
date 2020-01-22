classdef SheetVisibility
  % Indicates the visibility of a sheet within a workbook
  
  enumeration
    Hidden
    VeryHidden
    Visible
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.SheetVisibility.HIDDEN)
        out = jl.office.excel.SheetVisibility.Hidden;
      elseif jObj.equals(org.apache.poi.ss.usermodel.SheetVisibility.VERY_HIDDEN)
        out = jl.office.excel.SheetVisibility.VeryHidden;
      elseif jObj.equals(org.apache.poi.ss.usermodel.SheetVisibility.VISIBLE)
        out = jl.office.excel.SheetVisibility.Visible;
      else
        BADSWITCH
      end
    end
    
  end
        
	methods
    
    function out = toJava(this)
      if isempty(this)
        out = [];
      elseif this == jl.office.excel.Hidden
        out = jl.office.excel.SheetVisibility.HIDDEN;
      elseif this == jl.office.excel.VeryHidden
        out = jl.office.excel.SheetVisibility.VERY_HIDDEN;
      elseif this == jl.office.excel.Visible
        out = jl.office.excel.SheetVisibility.VISIBLE;
      else
        BADSWITCH
      end
    end
    
  end
  
end