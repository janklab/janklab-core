classdef TextRun < handle
% TextRun

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFTextRun Java object
    j
  end
  
  properties (Dependent)
    baselineOffset
    bold
    characterSpacing
    font
    fontColor
    fontSize
    italic
    strikethrough
    subscript
    superscript
    text
    textCap
    underline
  end

  methods

    function this = TextRun(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFTextRun');
      this.j = jObj;
    end

    function out = get.baselineOffset(this)
      out = this.j.getBaselineOffset;
    end
    
    function set.baselineOffset(this, val)
      this.j.setBaselineOffset(val);
    end
    
    function out = get.bold(this)
      out = this.j.isBold;
    end
    
    function set.bold(this, val)
      this.j.setBold(val);
    end
    
    function out = get.characterSpacing(this)
      out = this.j.getCharacterSpacing;
    end
    
    function set.characterSpacing(this, val)
      this.j.setCharacterSpacing(val);
    end
    
    function out = get.font(this)
      out = string(this.j.getFont);
    end
    
    function set.font(this, val)
      this.j.setFont(val);
    end
    
    function out = get.fontColor(this)
      out = this.j.getFontColor;
      % TODO: Should we wrap java.awt.Color in a Matlab object?
    end
    
    function set.fontColor(this, val)
      this.j.setFontColor(val);
    end
    
    function out = get.fontSize(this)
      out = this.j.getFontSize;
    end
    
    function set.fontSize(this, val)
      this.j.setFontSize(val);
    end
    
    function out = get.italic(this)
      out = this.j.isItalic;
    end
    
    function set.italic(this, val)
      this.j.setItalic(val);
    end
    
    function out = get.strikethrough(this)
      out = this.j.isStrikethrough;
    end
    
    function set.strikethrough(this, val)
      this.j.setStrikethrough(val);
    end
    
    function out = get.subscript(this)
      out = this.j.isSubscript;
    end
    
    function set.subscript(this, val)
      this.j.setSubscript(val);
    end
    
    function out = get.superscript(this)
      out = this.j.isSuperscript;
    end
    
    function set.superscript(this, val)
      this.j.setSuperscript(val);
    end
    
    function out = get.text(this)
      out = string(this.j.getText);
    end
    
    function set.text(this, val)
      this.j.setText(val);
    end
    
    function out = get.textCap(this)
      jObj = this.j.getTextCap;
      out = jl.office.excel.xlsx.TextCap.ofJava(jObj);
    end
    
    function out = get.underline(this)
      out = this.j.isUnderline;
    end
    
    function set.underline(this, val)
      this.j.setUnderline(val);
    end
  end

end
