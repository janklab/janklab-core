classdef HeaderFooter < jl.util.DisplayableHandle
  %HEADERFOOTER Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    j
  end
  
  properties (Dependent)
    center
    left
    right
  end
  
  methods

    function this = HeaderFooter(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.HeaderFooter');
      this.j = jObj;
    end
    
    function out = get.center(this)
      out = string(this.j.getCenter);
    end
    
    function set.center(this, val)
      this.j.setCenter(val);
    end
    
    function out = get.left(this)
      out = string(this.j.getLeft);
    end
    
    function set.left(this, val)
      this.j.setLeft(val);
    end
    
    function out = get.right(this)
      out = string(this.j.getRight);
    end
    
    function set.right(this, val)
      this.j.setRight(val);
    end
    
  end

  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[HeaderFooter: left=:"%s", center="%s", right="%s"]', ...
        this.left, this.center, this.right);
    end
    
  end
end
