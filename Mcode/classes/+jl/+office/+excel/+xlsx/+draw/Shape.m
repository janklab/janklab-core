classdef Shape < jl.office.excel.draw.Shape
% Shape

  properties (Dependent)
    lineStyle
    lineWidth
  end
  
  methods

    function this = Shape(varargin)
      this = this@jl.office.excel.draw.Shape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFShape');
    end
    
    function out = getDrawing(this)
      jObj = this.j.getDrawing;
      out = jl.office.excel.xlsx.draw.Drawing(jObj);
    end
    
    function out = getParent(this)
      jObj = this.j.getParent;
      out = jl.office.excel.xlsx.draw.ShapeGroup(jObj);
    end

    function set.lineStyle(this, val)
      this.j.setLineStyle(val);
    end
    
    function set.lineWidth(this, val)
      this.j.setLineWidth(val);
    end
    
  end

end
