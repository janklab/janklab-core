classdef (Abstract) Font < jl.util.DisplayableHandle
  % A font used in a workbook
  
  %#ok<*PROP>
 
  properties (Constant)
    AnsiCharset = org.apache.poi.ss.usermodel.Font.ANSI_CHARSET;
    ColorNormal = org.apache.poi.ss.usermodel.Font.COLOR_NORMAL;
    ColorRed = org.apache.poi.ss.usermodel.Font.COLOR_RED;
    DefaultCharset = org.apache.poi.ss.usermodel.Font.DEFAULT_CHARSET;
    SsNone = org.apache.poi.ss.usermodel.Font.SS_NONE;
    SsSub = org.apache.poi.ss.usermodel.Font.SS_SUB;
    SsSuper = org.apache.poi.ss.usermodel.Font.SS_SUPER;
    SymbolCharset = org.apache.poi.ss.usermodel.Font.SYMBOL_CHARSET;
    UDouble = org.apache.poi.ss.usermodel.Font.U_DOUBLE;
    UDoubleAccounting = org.apache.poi.ss.usermodel.Font.U_DOUBLE_ACCOUNTING;
    UNone = org.apache.poi.ss.usermodel.Font.U_NONE;
    USingle = org.apache.poi.ss.usermodel.Font.U_SINGLE;
    USingleAccounting = org.apache.poi.ss.usermodel.Font.U_SINGLE_ACCOUNTING;
  end  

  properties
    % The underlying org.apache.poi.ss.usermodel.Font object
    j
  end
  properties (Dependent)
    bold
    charSetIndex
    colorIndex
    fontHeight
    fontHeightInPoints
    fontName
    index
    italic
    strikeout
    typeOffsetCode
    underline
  end
  
  methods
    
    function out = get.bold(this)
      out = this.j.getBold;
    end
    
    function set.bold(this, val)
      this.j.setBold(val);
    end
    
    function out = get.charSetIndex(this)
      out = this.j.getCharSet;
    end
    
    function set.charSetIndex(this, val)
      this.j.setCharSet(val);
    end
    
    function out = get.colorIndex(this)
      out = this.j.getColor;
    end
    
    function set.colorIndex(this, val)
      this.j.setColor(val);
    end
    
    function out = get.fontHeight(this)
      out = this.j.getFontHeight;
    end
    
    function set.fontHeight(this, val)
      this.j.setFontHeight(val);
    end
    
    function out = get.fontHeightInPoints(this)
      out = this.j.getFontHeightInPoints;
    end
    
    function set.fontHeightInPoints(this, val)
      this.j.setFontHeightInPoints(val);
    end
    
    function out = get.fontName(this)
      out = char(this.j.getFontName);
    end
    
    function set.fontName(this, val)
      this.j.setFontName(val);
    end
    
    function out = get.index(this)
      out = this.j.getIndex;
    end
    
    function out = get.italic(this)
      out = this.j.getItalic;
    end
    
    function set.italic(this, val)
      this.j.setItalic(val);
    end
    
    function out = get.strikeout(this)
      out = this.j.getStrikeout;
    end
    
    function set.strikeout(this, val)
      this.j.setStrikeout(val);
    end
    
    function out = get.typeOffsetCode(this)
      out = this.j.getTypeOffset;
    end
    
    function set.typeOffsetCode(this, val)
      this.j.setTypeOffset(val);
    end
    
    function out = get.underline(this)
      out = this.j.getUnderline;
    end
    
    function set.underline(this, val)
      this.j.setUnderline(val);
    end
    
  end
  
  methods (Access = protected)
     
    function this = Font(varargin)
    end
    
    function out = dispstr_scalar(this)
      out = sprintf('%s (index=%d) height = %f (%f pts)', ...
        this.fontName, this.index, this.fontHeight, this.fontHeightInPoints);
      if this.bold
        out = [out ' BOLD'];
      end
      if this.italic
        out = [out ' ITALIC'];
      end
      if this.underline
        out = [out ' UNDERLINE'];
      end
      if this.strikeout
        out = [out ' STRIKEOUT'];
      end
      typeOffsetCode = this.typeOffsetCode;
      switch typeOffsetCode
        case org.apache.poi.ss.usermodel.Font.SS_NONE
          % NOP
        case org.apache.poi.ss.usermodel.Font.SS_SUPER
          out = [out ' SUPERSCRIPT'];
        case org.apache.poi.ss.usermodel.Font.SS_SUB
          out = [out ' SUBSCRIPT'];
      end
    end
    
  end
  
end