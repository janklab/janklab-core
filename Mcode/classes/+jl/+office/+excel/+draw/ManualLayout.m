classdef ManualLayout < handle
% ManualLayout

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.ManualLayout Java object
    j
  end

  properties (Dependent)
    heightMode
    heightRatio
    target
    widthMode
    widthRatio
    x
    xMode
    y
    yMode
  end
  
  methods

    function this = ManualLayout(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.ManualLayout');
      this.j = jObj;
    end

    function out = get.heightMode(this)
      jObj = this.j.getHeightMode;
      out = jl.office.excel.draw.LayoutMode.ofJava(jObj);
    end
    
    function set.heightMode(this, val)
      mustBeA(val, 'jl.office.excel.draw.LayoutMode');
      this.j.setHeightMode(val.j);
    end
    
    function out = get.heightRatio(this)
      out = this.j.getHeightRatio;
    end
    
    function set.heightRatio(this, val)
      this.j.setHeightRatio(val);
    end
    
    function out = get.target(this)
      jObj = this.j.getTarget;
      out = jl.office.excel.draw.LayoutTarget.ofJava(jObj);
    end
    
    function set.target(this, val)
      mustBeA(val, 'jl.office.excel.draw.LayoutTarget');
      this.j.setTarget(val.j);
    end
    
    function out = get.widthMode(this)
      jObj = this.j.getWidthMode;
      out = jl.office.excel.draw.LayoutMode.ofJava(jObj);
    end
    
    function set.widthMode(this, val)
      mustBeA(val, 'jl.office.excel.draw.LayoutMode');
      this.j.setWidthMode(val.j);
    end
    
    function out = get.widthRatio(this)
      out = this.j.getWidthRatio;
    end
    
    function set.widthRatio(this, val)
      this.j.setWidthRatio(val);
    end
    
    function out = get.x(this)
      out = this.j.getX;
    end
    
    function set.x(this, val)
      this.j.setX(val);
    end
    
    function out = get.xMode(this)
      jObj = this.j.getXMode;
      out = jl.office.excel.draw.LayoutMode.ofJava(jObj);
    end
    
    function set.xMode(this, val)
      mustBeA(val, 'jl.office.excel.draw.LayoutMode');
      this.j.setXMode(val.j);
    end
    
    function out = get.y(this)
      out = this.j.getY;
    end
    
    function set.y(this, val)
      this.j.setY(val);
    end
    
    function out = get.yMode(this)
      jObj = this.j.getYMode;
      out = jl.office.excel.draw.LayoutMode.ofJava(jObj);
    end
    
    function set.yMode(this, val)
      mustBeA(val, 'jl.office.excel.draw.LayoutMode');
      this.j.setYMode(val.j);
    end
    
  end

end
