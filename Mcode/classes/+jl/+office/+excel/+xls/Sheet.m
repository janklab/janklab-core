classdef Sheet < jl.office.excel.Sheet
  
  methods
    
    function this = Sheet(workbook, jObj)
      if nargin == 0
        return
      else
        mustBeA(workbook, 'jl.office.excel.Workbook');
        mustBeA(jObj, 'org.apache.poi.hssf.usermodel.HSSFSheet');
        this.workbook = workbook;
        this.j = jObj;
      end
      this.cells = jl.office.excel.FriendlyCellView(this);
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapRowObject(this, jRow)
      out = jl.office.excel.xls.Row(this, jRow);
    end
    
  end
  
end