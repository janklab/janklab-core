classdef SimpleShape < jl.office.excel.draw.SimpleShape & jl.office.excel.xlsx.draw.Shape
  % SimpleShape
  
  properties (Dependent)
    bottomInset
    leftInset
    rightInset
    shapeType
    text
    textAutofit
    textDirection
    textHorizontalOverflow
    textVerticalOverflow
    topInset
    verticalAlignment
    wordWrap
  end
  
  methods
    
    function this = SimpleShape(varargin)
      this = this@jl.office.excel.xlsx.draw.Shape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFSimpleShape');
    end
    
    function out = get.bottomInset(this)
      out = this.j.getBottomInset;
    end
    
    function set.bottomInset(this, val)
      this.j.setBottomInset(val);
    end
    
    function out = get.leftInset(this)
      out = this.j.getLeftInset;
    end
    
    function set.leftInset(this, val)
      this.j.setLeftInset(val);
    end
    
    function out = get.rightInset(this)
      out = this.j.getRightInset;
    end
    
    function set.rightInset(this, val)
      this.j.setRightInset(val);
    end
    
    function out = get.shapeType(this)
      out = this.j.getShapeType;
    end
    
    function set.shapeType(this, val)
      this.j.setShapeType(val);
    end
    
    function out = get.text(this)
      out = string(this.j.getText);
    end
    
    function set.text(this, val)
      this.j.setText(string(val));
    end
    
    function out = get.textAutofit(this)
      jObj = this.j.getTextAutofit;
      out = jl.office.excel.xlsx.TextAutofit.ofJava(jObj);
    end
    
    function set.textAutofit(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.TextAutofit');
      this.j.setTextAutofit(val.j);
    end
    
    function out = get.textDirection(this)
      jObj = this.j.getTextDirection;
      out = jl.office.excel.xlsx.TextDirection.ofJava(jObj);
    end
    
    function set.textDirection(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.TextDirection');
      this.j.setTextDirection(val.j);
    end
    
    function out = get.textHorizontalOverflow(this)
      jObj = this.j.getTextHorizontalOverflow;
      out = jl.office.excel.xlsx.TextHorizontalOverflow.ofJava(jObj);
    end
    
    function set.textHorizontalOverflow(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.TextHorizontalOverflow');
      this.j.setTextHorizontalOverflow(val.j);
    end
    
    function out = getTextParagraphs(this)
      UNIMPLEMENTED
    end
    
    function out = get.textVerticalOverflow(this)
      jObj = this.j.getTextVerticalOverflow;
      out = jl.office.excel.xlsx.TextVerticalOverflow.ofJava(jObj);
    end
    
    function set.textVerticalOverflow(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.TextVerticalOverflow');
      this.j.setTextVerticalOverflow(val.j);
    end
    
    function out = get.topInset(this)
      out = this.j.getTopInset;
    end
    
    function set.topInset(this, val)
      this.j.setTopInset(val);
    end
    
    function out = get.verticalAlignment(this)
      jObj = this.j.getVerticalAlignment;
      out = jl.office.excel.VerticalAlignment.ofJava(jObj);
    end
    
    function set.verticalAlignment(this, val)
      mustBeA(val, 'jl.office.excel.VerticalAlignment');
      this.j.setVerticalAlignment(val.j);
    end
    
    function out = get.wordWrap(this)
      out = this.j.getWordWrap;
    end
    
    function set.wordWrap(this, val)
      this.j.setWordWrap(val);
    end
    
    function out = addNewTextParagraph(this, varargin)
      jObj = this.j.addNewTextParagraph(varargin{:});
      out = jl.office.excel.xlsx.TextParagraph(jObj);
    end
    
  end
  
end