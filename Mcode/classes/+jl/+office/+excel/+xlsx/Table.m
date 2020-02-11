classdef Table < handle
% Table

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFTable Java object
    j
  end
  
  properties (Dependent)
    displayName
    name
    styleName
    endCellReference
    endColIndex
    endRowIndex
    headerRowCount
    numMappedColumns
    rowCount
    sheetName
    startCellReference
    startColIndex
    startRowIndex
    style
  end

  methods

    function this = Table(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFTable');
      this.j = jObj;
    end
    
    function addColumn(this)
      this.j.addColumn;
    end
    
    function out = contains(this, cell)
      mustBeA(cell, 'jl.office.excel.Cell');
      out = this.j.contains(cell.j);
    end
    
    function out = findColumnIndex(this, columnHeader)
      out = this.j.findColumnIndex(columnHeader) + 1;
    end
    
    function out = getCellReferences(this)
      jObj = this.j.getCellReferences;
      out = jl.office.excel.AreaReference(jObj);
    end
    
    function out = getCommonXpath(this)
      out = string(this.j.getCommonXpath);
    end
    
    function out = get.displayName(this)
      out = string(this.j.getDisplayNam);
    end
    
    function set.displayName(this, val)
      this.j.setDisplayName(val);
    end
    
    function out = get.endCellReference(this)
      jObj = this.j.getEndCellReference;
      out = jl.office.excel.CellReference(jObj);
    end
    
    function out = get.endColIndex(this)
      out = this.j.getEndColIndex + 1;
    end
    
    function out = get.endRowIndex(this)
      out = this.j.getEndRowIndex + 1;
    end
    
    function out = get.name(this)
      out = string(this.j.getName);
    end
    
    function set.name(this, val)
      this.j.setName(val);
    end
    
    function out = get.startCellReference(this)
      jObj = this.j.getStartCellReference;
      out = jl.office.excel.CellReference(jObj);
    end
    
    function out = get.startColIndex(this)
      out = this.j.getStartColIndex + 1;
    end
    
    function out = get.startRowIndex(this)
      out = this.j.getStartRowIndex + 1;
    end
    
    function out = get.headerRowCount(this)
      out = this.j.getHeaderRowCount;
    end
    
    function out = get.numMappedColumns(this)
      out = this.j.getNumberOfMappedColumns;
    end
    
    function out = get.rowCount(this)
      out = this.j.getRowCount;
    end
    
    function out = get.sheetName(this)
      out = string(this.j.getSheetName);
    end
    
    function out = get.style(this)
      jObj = this.j.getStyle;
      out = jl.office.excel.xlsx.TableStyleInfo(jObj);
    end
    
    function updateHeaders(this)
      this.j.updateHeaders;
    end
    
    function updateReferences(this)
      this.j.updateReferences;
    end
    
  end

end
