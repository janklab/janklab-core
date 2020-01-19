classdef CellStyle < jl.util.DisplayableHandle
  
  properties
    % The underlying org.apache.poi.ss.usermodel.CellStyle object
    j
    % The parent Workbook
    wkbk
  end
  
  properties (Dependent)
    borderBottom
    borderLeft
    borderRight
    borderTop
    borderColorBottom
    borderColorLeft
    borderColorRight
    borderColorTop
    dataFormat
    dataFormatIndex
    fillBackgroundColor
    fillBackgroundColorIndex
    fillForegroundColor
    fillForegroundColorIndex
    fillPattern
    fontIndex
    horizontalAlignment
    hidden
    indentation
    indexInWorkbook
    locked
    quotePrefixed
    rotation
    shrinkToFit
    verticalAlignment
    wrapText
  end
  
  methods
    
    function cloneFrom(this, other)
      mustBeA(other, 'jl.office.excel.CellStyle');
      this.j.cloneFrom(other.j);
    end
    
    function out = get.horizontalAlignment(this)
      jObj = this.j.getAlignment;
      if isempty(jObj)
        out = [];
      else
        out = jl.office.excel.HorizontalAlignment.ofJava(jObj);
      end
    end
    
    function set.horizontalAlignment(this, val)
      mustBeA(val, 'jl.office.excel.HorizontalAlignment');
      this.j.setAlignment(val.toJava);
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[CellStyle: ]');
    end
    
  end
end