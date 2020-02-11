classdef GraphicFrame < jl.office.excel.xlsx.draw.Shape
% GraphicFrame

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFGraphicFrame Java object
    j
  end

  properties (Dependent)
    anchor
    id
    name
    shapeName
  end
  
  methods

    function this = GraphicFrame(varargin)
      this = this@jl.office.excel.xlsx.draw.Shape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFGraphicFrame');
    end
    
    function out = get.anchor(this)
      jObj = this.j.getAnchor;
      out = jl.office.excel.ClientAnchor(jObj);
    end
    
    function set.anchor(this, val)
      mustBeA(val, 'jl.office.excel.ClientAnchor');
      this.j.setAnchor(val.j);
    end
    
    function out = get.id(this)
      out = this.j.getId;
    end
    
    function set.id(this, val)
      this.j.setId(val);
    end
    
    function out = get.name(this)
      out = string(this.j.getName);
    end
    
    function set.name(this, val)
      this.j.setName(string(val));
    end
    
    function out = get.shapeName(this)
      out = string(this.j.getShapeName);
    end
    
    function setChart(this, chart, relId)
      mustBeA(chart, 'jl.office.excel.xlsx.draw.Chart');
      this.setChart(chart.j, relId);
    end

    function setMacro(this, macro)
      mustBeStringy(macro);
      this.j.setMacro(macro);
    end
    
  end

end
