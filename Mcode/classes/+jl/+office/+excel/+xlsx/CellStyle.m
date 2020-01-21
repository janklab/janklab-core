classdef CellStyle < jl.office.excel.CellStyle
  
  methods
    
    function this = CellStyle(wkbk, jObj)
      if nargin == 0
        return
      else
        mustBeA(wkbk, 'jl.office.excel.Workbook');
        mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFCellStyle');
        this.wkbk = wkbk;
        this.j = jObj;
      end
    end
    
  end
  
  methods (Access = protected)
        
  end
  
end