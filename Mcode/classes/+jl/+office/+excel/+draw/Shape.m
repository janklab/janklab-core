classdef Shape < handle
% Shape

  properties
    % The underlying POI org.apache.poi.ss.usermodel.Shape Java object
    j
  end

  properties (Dependent)
    anchor
    shapeName
    noFill
  end
  
  methods

    function this = Shape(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.Shape');
      this.j = jObj;
    end

    function out = get.anchor(this)
      jObj = this.j.getAnchor;
      out = jl.office.excel.draw.ChildAnchor(jObj);
    end
    
    function out = getParent(this)
      jObj = this.j.getParent;
      out = jl.office.excel.draw.Shape(jObj);
    end
    
    function out = get.shapeName(this)
      out = string(this.j.getShapeName);
    end
    
    function out = get.noFill(this)
      out = this.j.isNoFill;
    end
    
    function set.noFill(this, val)
      this.j.setNoFill(val);
    end
    
    function setFillColor(red, green, blue)
      this.j.setFillColor(red, green, blue);
    end
    
    function setLineStyleColor(red, green, blue)
      this.j.setLineStyleColor(red, green, blue);
    end
    
  end

end
