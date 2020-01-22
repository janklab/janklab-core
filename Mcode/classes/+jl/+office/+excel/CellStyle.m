classdef CellStyle < handle
  
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
      out = jl.office.excel.HorizontalAlignment.ofJava(jObj);
    end
    
    function set.horizontalAlignment(this, val)
      mustBeA(val, 'jl.office.excel.HorizontalAlignment');
      this.j.setAlignment(val.toJava);
    end
    
    function out = get.borderBottom(this)
      jObj = this.j.getBorderBottom;
      out = jl.office.excel.HorizontalAlignment.ofJava(jObj);
    end
    
    function set.borderBottom(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderBottom(val.toJava);
    end
    
    function out = get.borderLeft(this)
      jObj = this.j.getBorderLeft;
      out = jl.office.excel.HorizontalAlignment.ofJava(jObj);
    end
    
    function set.borderLeft(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderBottom(val.toJava);
    end
    
    function out = get.borderRight(this)
      jObj = this.j.getBorderBottom;
      out = jl.office.excel.HorizontalAlignment.ofJava(jObj);
    end
    
    function set.borderRight(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderBottom(val.toJava);
    end
    
    function out = get.borderTop(this)
      jObj = this.j.getBorderBottom;
      out = jl.office.excel.HorizontalAlignment.ofJava(jObj);
    end
    
    function set.borderTop(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderBottom(val.toJava);
    end
    
    function out = get.borderColorBottom(this)
      out = this.j.getBottomBorderColor;
    end
    
    function out = get.borderColorLeft(this)
      out = this.j.getLeftBorderColor;
    end
    
    function out = get.borderColorRight(this)
      out = this.j.getRightBorderColor;
    end
    
    function out = get.borderColorTop(this)
      out = this.j.getTopBorderColor;
    end
    
    function out = get.dataFormat(this)
      out = string(this.j.getDataFormatString);
    end
    
    function set.dataFormatIndex(this, val)
      this.j.setDataFormat(val);
    end
    
    function out = get.dataFormatIndex(this)
      out = this.j.getDataFormat;
    end
    
    function out = get.fillBackgroundColor(this)
      UNIMPLEMENTED;
    end
    
    function set.fillBackgroundColor(this, val)
      UNIMPLEMENTED;
    end
    
    function out = get.fillBackgroundColorIndex(this)
      out = this.j.getFillBackgroundColor;
    end
    
    function set.fillBackgroundColorIndex(this, val)
      this.j.setFillBackgroundColor(val);
    end
    
    function out = get.fillPattern(this)
      jObj = this.j.getFillPattern;
      out = jl.office.excel.FillPattern.ofJava(jObj);
    end
    
    function set.fillPattern(this, val)
      mustBeA(val, 'jl.office.excel.FillPattern';
      this.j.setFillPattern(val.toJava);
    end
    
    function out = get.fontIndex(this)
      out = this.j.getFontIndexAsInt;
    end
    
    function out = get.hidden(this)
      out = this.j.getHidden;
    end
    
    function set.hidden(this, val)
      this.j.setHidden(val);
    end
    
    function out = get.indentation(this)
      out = this.j.getIndentation;
    end
    
    function set.indentation(this, val)
      this.j.setIndentation(val);
    end
    
    function out = get.indexInWorkbook(this)
      out = this.j.getIndex;
    end
    
    function out = get.locked(this)
      out = this.j.getLocked;
    end
    
    function set.locked(this, val)
      this.j.setLocked(val);
    end
    
    function out = get.quotePrefixed(this)
      out = this.j.getQuotePrefixed;
    end
    
    function set.quotePrefixed(this, val)
      this.j.setQuotePrefixed(val);
    end
    
    function out = get.rotation(this)
      out = this.j.getRotation;
    end
    
    function set.rotation(this, val)
      this.j.setRotation(this, val);
    end
    
    function out = get.shrinkToFit(this)
      out = this.j.getShrinkToFit;
    end
    
    function set.shrinkToFit(this, val)
      this.j.setShrinkToFit(val);
    end
    
    function out = get.verticalAlignment(this)
      out = jl.office.excel.VerticalAlignment.ofJava(this.j.getVerticalAlignment);
    end
    
    function set.verticalAlignment(this, val)
      mustBeA(val, 'jl.office.excel.VerticalAlignment');
      this.j.setVerticalAlignment(val.toJava);
    end
    
    function out = get.wrapText(this)
      out = this.j.getWrapText;
    end
    
    function set.wrapText(this, val)
      this.j.setWrapText(val);
    end
  end
  
end