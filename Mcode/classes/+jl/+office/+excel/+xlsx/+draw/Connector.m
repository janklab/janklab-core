classdef Connector < jl.office.excel.xlsx.draw.Shape
% Connector

  properties (Dependent)
    shapeName
    shapeType
  end
  
  methods

    function this = Connector(varargin)
      this = this@jl.office.excel.xlsx.draw.Shape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFConnector');
    end

    function out = get.shapeName(this)
      out = string(this.j.getShapeName);
    end
    
    function out = get.shapeType(this)
      out = this.j.getShapeType;
    end
    
    function set.shapeType(this, val)
      this.j.setShapeType(val);
    end
    
  end

end
