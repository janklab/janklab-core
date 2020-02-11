classdef (Abstract) SimpleShape < jl.office.excel.draw.Shape
% SimpleShape

  properties (Dependent)
    shapeId
  end
  
  methods

    function this = SimpleShape(varargin)
      this = this@jl.office.excel.draw.Shape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.ss.usermodel.SimpleShape');
    end

    function out = get.shapeId(this)
      out = this.j.getShapeId;
    end
    
  end

end
