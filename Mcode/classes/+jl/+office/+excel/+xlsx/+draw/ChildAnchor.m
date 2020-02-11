classdef ChildAnchor < handle
% ChildAnchor

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFChildAnchor Java object
    j
  end

  properties (Dependent)
    dx1
    dx2
    dy1
    dy2
  end
  
  methods

    function this = ChildAnchor(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFChildAnchor');
      this.j = jObj;
    end
    
    function out = get.dx1(this)
      out = this.j.getDx1;
    end
    
    function set.dx1(this, val)
      this.j.setDx1(val);
    end

    function out = get.dx2(this)
      out = this.j.getDx2;
    end
    
    function set.dx2(this, val)
      this.j.setDx2(val);
    end

    function out = get.dy1(this)
      out = this.j.getDy1;
    end
    
    function set.dy1(this, val)
      this.j.setDy1(val);
    end

    function out = get.dy2(this)
      out = this.j.getDy2;
    end
    
    function set.dy2(this, val)
      this.j.setDy2(val);
    end

  end

end
