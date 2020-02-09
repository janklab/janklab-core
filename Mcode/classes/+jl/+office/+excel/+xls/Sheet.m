classdef Sheet < jl.office.excel.Sheet
  
  properties (Dependent)
    header
    footer
  end
  
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
      this.jIoHelper = net.janklab.office.excel.SheetIOHelper(jObj);
    end
    
    function out = get.footer(this)
      out = jl.office.excel.HeaderFooter(this.j.getFooter);
    end
    
    function out = get.header(this)
      out = jl.office.excel.HeaderFooter(this.j.getHeader);
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapRowObject(this, jRow)
      out = jl.office.excel.xls.Row(this, jRow);
    end
    
    function out = wrapCellStyleObject(this, jObj) %#ok<INUSL>
      out = jl.office.excel.xls.CellStyle(jObj);
    end
  
  end
  
end