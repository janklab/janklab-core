classdef TextParagraph < handle
% TextParagraph

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFTextParagraph Java object
    j
  end
  
  properties (Dependent)
    bulletAutoNumberScheme
    bulletAutoNumberStart
    bulletCharacter
    bulletFont
    bulletFontColor
    bulletFontSize
    defaultTabSize
    indent
    isBullet
    isBulletAutoNumber
    leftMargin
    level
    lineSpacing
    rightMargin
    spaceAfter
    spaceBefore
    text
    textAlign
    textFontAlign
    
  end

  methods

    function this = TextParagraph(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFTextParagraph');
      this.j = jObj;
    end

    function out = get.bulletAutoNumberScheme(this)
      jObj = this.j.getBulletAutoNumberScheme;
      out = jl.office.excel.xlsx.ListAutoNumber.ofJava(jObj);
    end
    
    function out = get.bulletAutoNumberStart(this)
      out = this.j.getBulletAutoNumberStart;
    end
    
    function out = get.bulletCharacter(this)
      out = string(this.j.getBulletCharacter;
    end
    
    function set.bulletCharacter(this, val)
      this.j.setBulletCharacter(val);
    end
    
    function out = get.bulletFont(this)
      out = string(this.j.getBulletFont);
    end
    
    function set.bulletFont(this, val)
      this.j.setBulletFont(val);
    end
    
    function out = get.bulletFontColor(this)
      out = this.j.getBulletFontColor;
      % TODO: Should we wrap java.awt.Color in a Matlab object?
    end
    
    function set.bulletFontColor(this, val)
      this.j.setBulletFontColor(val);
    end
    
    function out = get.bulletFontSize(this)
      out = this.j.getBulletFontSize;
    end
    
    function set.bulletFontSize(this, val)
      this.j.setBulletFontSize(val);
    end
    
    function out = get.defaultTabSize(this)
      out = this.j.getDefaultTabSize;
    end
    
    function out = get.indent(this)
      out = this.j.getIndent;
    end
    
    function set.indent(this, val)
      this.j.setIndent(val);
    end
    
    function out = get.isBullet(this)
      out = this.j.isBullet;
    end
    
    function set.bullet(this, val)
      this.j.setBullet(val);
    end
    
    function setBullet(this, autoNumberScheme, startAt)
      mustBeA(autoNumberScheme, 'jl.office.excel.xlsx.ListAutoNumber');
      if nargin == 2
        this.j.setBullet(autoNumberScheme.j);
      else
        this.j.setBullet(autoNumberScheme.j, startAt);
      end
    end
    
    function out = get.leftMargin(this)
      out = this.j.getLeftMargin;
    end
    
    function set.leftMargin(this, val)
      this.j.setLeftMargin(val);
    end
    
    function out = get.level(this)
      out = this.j.getLevel;
    end
    
    function set.level(this, val)
      this.j.setLevel(val);
    end
    
    function out = get.lineSpacing(this)
      out = this.j.getLineSpacing;
    end
    
    function set.lineSpacing(this, val)
      this.j.setLineSpacing(val);
    end
    
    function out = get.rightMargin(this)
      out = this.j.getRightMargin;
    end
    
    function set.rightMargin(this, val)
      this.j.setRightMargin(val);
    end
    
    function out = get.spaceAfter(this)
      out = this.j.getSpaceAfter;
    end
    
    function set.spaceAfter(this, val)
      this.j.setSpaceAfter(val);
    end
    
    function out = get.spaceBefore(this)
      out = this.j.getSpaceBefore;
    end
    
    function set.spaceBefore(this, val)
      this.j.setSpaceBefore(val);
    end
    
    function out = getText(this)
      out = string(this.j.getText);
    end
    
    function out = get.textAlign(this)
      jObj = this.j.getTextAlign;
      out = jl.office.excel.xlsx.TextAlign.ofJava(jObj);
    end
    
    function set.textAlign(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.TextAlign');
      this.j.setTextAlign(val.j);
    end
    
    function out = get.textFontAlign(this)
      jObj = this.j.getTextFontAlign;
      out = jl.office.excel.xlsx.TextFontAlign.ofJava(jObj);
    end
    
    function set.textFontAlign(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.TextFontAlign');
      this.j.setTextFontAlign(val.j);
    end
    
    function out = getTextRuns(this)
      jList = this.j.getTextRuns;
      out = repmat(jl.office.excel.xlsx.TextRun, [1 jList.size]);
      for i = 1:numel(out)
        out(i) = jList.get(i);
      end
    end
    
  end

end
