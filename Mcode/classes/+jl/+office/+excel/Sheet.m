classdef (Abstract) Sheet < jl.util.DisplayableHandle
  
  properties
    % The underlying POI XSSFSheet object
    j
    % The parent workbook
    workbook
    % A FriendlyCellView into this sheet, which lets you view the sheet's
    % cells as a Matlab array
    cells
  end
  
  properties (Dependent)
    activeCellAddress
    autobreaks
    firstRowNum
    lastRowNum
    name
    nRows
    nCols
  end
  
  methods
        
    function out = get.activeCellAddress(this)
      out = jl.office.excel.CellAddress(this.j.getActiveCell);
    end
    
    function set.activeCellAddress(this, val)
      mustBeA(val, 'jl.office.excel.CellAddress');
      this.j.setActiveCell(val.j);
    end
    
    function out = get.autobreaks(this)
      out = this.j.getAutobreaks;
    end
    
    function set.autobreaks(this, val)
      this.j.setAutobreaks(val);
    end
    
    function out = get.lastRowNum(this)
      out = this.j.getLastRowNum;
    end
    
    function out = get.firstRowNum(this)
      out = this.j.getFirstRowNum + 1;
    end
    
    function out = get.name(this)
      out = string(this.j.getSheetName);
    end
    
    function out = get.nRows(this)
      out = this.j.getLastRowNum;
    end
    
    function out = get.nCols(this)
      out = 0;
      for iRow = 1:this.nRows
        row = this.getRow(iRow);
        out = max(out, row.nCols);
      end
    end
    
    function out = getRow(this, rowNum)
      jRow = this.j.getRow(rowNum - 1);
      if isempty(jRow)
        out = [];
        return
      end
      out = this.wrapRowObject(this, jRow);
    end
    
    function out = createRow(this, rowNum)
      jRow = this.j.createRow(rowNum - 1);
      out = this.wrapRowObject(this, jRow);
    end
    
  end

  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[Sheet: name=''%s'']', ...
        this.name);
    end
    
  end
  
  methods (Abstract, Access = protected)
    
    out = wrapRowObject(this, jRow)
    
  end
  
end