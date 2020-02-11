classdef BorderFormatting < handle
  
  properties
    j
  end
  
  properties (Dependent)
    bottom
    bottomColor
    diagonal
    diagonalColor
    horizontal
    horizontalColor
    left
    leftColor
    right
    rightColor
    top
    topColor
    vertical
    verticalColor
  end
  
  methods
    
    function this = BorderFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.BorderFormatting');
      this.j = jObj;
    end
    
    function out = get.bottom(this)
      out = jl.office.excel.BorderStyle(this.j.getBorderBottom);
    end
    
    function out = get.bottomColor(this)
      out = jl.office.excel.Color(this.j.getBottomBorderColorColor);
    end
    
    function set.bottom(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderBottom(val.j);
    end
    
    function set.bottomColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setBottomBorderColor(val.j);
    end
    
    function out = get.diagonal(this)
      out = jl.office.excel.BorderStyle(this.j.getBorderDiagonal);
    end
    
    function out = get.diagonalColor(this)
      out = jl.office.excel.Color(this.j.getDiagonalBorderColorColor);
    end
    
    function set.diagonal(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderDiagonal(val.j);
    end
    
    function set.diagonalColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setDiagonalBorderColor(val.j);
    end
    
    function out = get.horizontal(this)
      out = jl.office.excel.BorderStyle(this.j.getBorderHorizontal);
    end
    
    function out = get.horizontalColor(this)
      out = jl.office.excel.Color(this.j.getHorizontalBorderColorColor);
    end
    
    function set.horizontal(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderHorizontal(val.j);
    end
    
    function set.horizontalColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setHorizontalBorderColor(val.j);
    end
    
    function out = get.left(this)
      out = jl.office.excel.BorderStyle(this.j.getBorderLeft);
    end
    
    function out = get.leftColor(this)
      out = jl.office.excel.Color(this.j.getLeftBorderColorColor);
    end
    
    function set.left(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderLeft(val.j);
    end
    
    function set.leftColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setleftBorderColor(val.j);
    end
    
    function out = get.right(this)
      out = jl.office.excel.BorderStyle(this.j.getBorderRight);
    end
    
    function out = get.rightColor(this)
      out = jl.office.excel.Color(this.j.getRightBorderColorColor);
    end
    
    function set.right(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderRight(val.j);
    end
    
    function set.rightColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setRightBorderColor(val.j);
    end
    
    function out = get.top(this)
      out = jl.office.excel.BorderStyle(this.j.getBorderTop);
    end
    
    function out = get.topColor(this)
      out = jl.office.excel.Color(this.j.getTopBorderColorColor);
    end
    
    function set.top(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setTopBottom(val.j);
    end
    
    function set.topColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setTopBorderColor(val.j);
    end
    
    function out = get.vertical(this)
      out = jl.office.excel.BorderStyle(this.j.getBorderVertical);
    end
    
    function out = get.verticalColor(this)
      out = jl.office.excel.Color(this.j.getVerticalBorderColorColor);
    end
    
    function set.vertical(this, val)
      mustBeA(val, 'jl.office.excel.BorderStyle');
      this.j.setBorderVertical(val.j);
    end
    
    function set.verticalColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setVerticalBorderColor(val.j);
    end
    
  end
  
end

