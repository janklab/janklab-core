classdef Cell < jl.office.excel.Cell
  
  methods
    
    function this = Cell(row, jObj)
      if nargin == 0
        return
      else
        mustBeA(row, 'jl.office.excel.Row');
        mustBeA(jObj, 'org.apache.poi.hssf.usermodel.HSSFCell');
        this.row = row;
        this.j = jObj;
      end
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapCellObject(this, jCell)
      out = jl.office.excel.xls.Cell(this, jCell);
    end
    
    function out = wrapCellStyleObject(this, jObj)
      out = jl.office.excel.xls.CellStyle(this.row.sheet.workbook, jObj);
    end
    
  end
  
end