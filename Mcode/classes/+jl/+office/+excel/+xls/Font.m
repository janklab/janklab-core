classdef Font < jl.office.excel.Font
  
  properties (Constant)
    Arial = org.apache.poi.hssf.usermodel.HSSFFont.FONT_ARIAL;
  end
  
  methods
    
    function this = Font(jObj)
      mustBeA(jObj, 'org.apache.poi.hssf.usermodel.HSSFFont');
      this.j = jObj;
    end
    
  end
  
end