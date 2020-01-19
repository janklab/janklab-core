classdef Row < jl.office.excel.Row
  
  methods
    
    function this = Row(sheet, jObj)
      if nargin == 0
        return
      else
        mustBeA(sheet, 'jl.office.excel.Sheet');
        mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFRow');
        this.sheet = sheet;
        this.j = jObj;
      end
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapCellObject(this, jCell)
      out = jl.office.excel.xssf.Cell(this, jCell);
    end
    
  end
  
end