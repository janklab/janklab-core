classdef Cell < jl.office.excel.Cell
  
  methods
    
    function this = Cell(row, jObj)
      if nargin == 0
        return
      else
        mustBeA(row, 'jl.office.excel.Row');
        mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFCell');
        this.row = row;
        this.j = jObj;
      end
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapCellObject(this, jCell)
      out = jl.office.excel.xlsx.Cell(this, jCell);
    end
    
  end
  
end