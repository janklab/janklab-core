classdef (Abstract) FontFormatting < handle
  %FONTFORMATTING 
  
  properties
    j
  end
  
  properties (Dependent)
    escapementType
    fontColor
    fontColorIndex
    fontHeight
    isBold
    isItalic
    isStruckout
    underlineType
  end
  
  methods
    
    function this = FontFormatting(jObj)
      if nargin == 1
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel');
      this.j = jObj;
    end
    
    function resetFontStyle(this)
      this.j.resetFontStyle;
    end
    
    function out = get.escapementType(this)
      out = jl.office.excel.condformat.EscapementType.ofJava(this.j.getEscapementType);
    end

    function set.escapementType(this, val)
      mustBeA(val, 'jl.office.excel.condformat.EscapementType');
      this.j.setEscapementType(val.toJava);
    end
    
    function out = get.fontColor(this)
      out = jl.office.excel.Color(this.j.getFontColor);
    end
    
    function set.fontColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setFontColor(val.j);
    end
    
    function out = get.fontColorIndex(this)
      out = this.j.getFontColorIndex;
    end
    
    function set.fontColorIndex(this, val)
      this.j.setFontColorIndex(val);
    end
    
    function out = get.fontHeight(this)
      out = this.j.getFontHeight;
    end
    
    function set.fontHeight(this, val)
      this.j.setFontHeight(val);
    end
    
    function out = get.underlineType(this)
      out = jl.office.excel.condformat.UnderlineType.ofJava(this.j.getUnderlineType);
    end
    
    function set.underlineType(this, val)
      mustBeA(val, 'jl.office.excel.condformat.UnderlineType');
      this.j.setUnderlineType(val.toJava);
    end
    
    function out = get.isBold(this)
      out = this.j.isBold;
    end
    
    function set.isBold(this, val)
      this.j.setBold(this, val);
    end
    
    function out = get.isItalic(this)
      out = this.j.isItalic;
    end
    
    function set.isItalic(this, val)
      this.j.setItalic(val);
    end
    
    function out = get.isStruckout(this)
      out = this.j.isStruckout;
    end
    
    function set.isStruckout(this, val)
      this.setIsStruckout(val);
    end
    
  end
  
  methods (Abstract, Access = protected)
    setIsStruckout(this, val)
  end
  
end

