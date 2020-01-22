classdef SpreadsheetVersion < handle
  
  properties
    % The underlying Java POI object
    j
  end
  
  properties (Dependent)
    name
    lastColumnIndex
    lastColumnName
    lastRowIndex
    maxCellStyles
    maxColumns
    maxConditionalFormats
    maxFunctionArgs
    maxRows
    maxTextLength
  end
    
  methods
    
    function this = SpreadsheetVersion(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.SpreadsheetVersion');
      this.j = jObj;
    end
    
    function out = get.name(this)
      out = string(this.j.toString);
    end
    
    function out = get.lastColumnIndex(this)
      out = this.j.getLastColumnIndex;
    end
    
    function out = get.lastColumnName(this)
      out = this.j.getLastColumnName;
    end
    
    function out = get.lastRowIndex(this)
      out = this.j.getLastRowIndex;
    end
    
    function out = get.maxCellStyles(this)
      out = this.j.getMaxCellStyles;
    end
    
    function out = get.maxColumns(this)
      out = this.j.getMaxColumns;
    end
    
    function out = get.maxConditionalFormats(this)
      out = this.j.getMaxConditionalFormats;
    end
    
    function out = get.maxFunctionArgs(this)
      out = this.j.getMaxFunctionArgs;
    end
    
    function out = get.maxRows(this)
      out = this.j.getMaxRows;
    end
    
    function out = get.maxTextLength(this)
      out = this.j.getMaxTextLength;
    end
    
  end
  
end
  