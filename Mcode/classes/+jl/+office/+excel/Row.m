classdef (Abstract) Row < jl.util.DisplayableHandle
  
  properties
    % The underlying POI Row object
    j
    % The parent Sheet
    sheet
  end
  
  properties (Dependent)
    height
    heightInPoints
    outlineLevel
    rowNum
    rowStyle
    isZeroHeight
    isFormatted
    firstCellNum
    lastCellNum
    nCells
  end
  
  methods
        
    function out = get.firstCellNum(this)
      out = this.j.getFirstCellNum;
      if out >= 0
        % Convert to 1-indexing
        out = out + 1;
      end
    end
    
    function out = get.lastCellNum(this)
      out = this.j.getLastCellNum;
      % This value is already 1-indexed
    end
    
    function out = get.nCells(this)
      out = this.lastCellNum;
    end
    
    function out = get.height(this)
      out = this.j.getHeight;
    end
    
    function set.height(this, val)
      this.j.setHeight(val);
    end
    
    function out = get.heightInPoints(this)
      out = this.j.getHeightInPoints;
    end
    
    function set.heightInPoints(this, val)
      this.j.setHeightInPoints(val);
    end
    
    function out = get.outlineLevel(this)
      out = this.j.getOutlineLevel;
    end
    
    function out = get.rowNum(this)
      out = this.j.getRowNum;
    end
    
    function set.rowNum(this, val)
      this.j.setRowNum(val);
    end
    
    function out = get.rowStyle(this)
      UNIMPLEMENTED
    end
    
    function set.rowStyle(this, val)
      UNIMPLEMENTED
    end
    
    function out = get.isZeroHeight(this)
      out = this.j.getZeroHeight;
    end
    
    function set.isZeroHeight(this, val)
      this.j.setZeroHeight(val);
    end
    
    function out = get.isFormatted(this)
      out = this.j.isFormatted;
    end
    
    function out = getCell(this, ixCol)
      jCell = this.j.getCell(ixCol - 1);
      if isempty(jCell)
        out = [];
        return
      end
      out = this.wrapCellObject(this, jCell);
    end
    
    function out = createCell(this, ixCol)
      jCell = this.j.createCell(ixCol - 1);
      out = this.wrapCellObject(jCell);
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[Row: rowNum=%d]', ...
        this.rowNum);
    end
    
  end
  
  methods (Abstract, Access = protected)
    
    out = wrapCellObject(this, jCell)
    
  end
  
end
