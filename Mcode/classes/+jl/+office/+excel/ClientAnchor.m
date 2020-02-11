classdef ClientAnchor < handle
  %CLIENTANCHOR
  
  properties
    j
  end
  properties (Dependent)
    anchorType
    col1
    col2
    dx1
    dx2
    dy1
    dy2
    row1
    row2
  end
  
  methods
    
    function this = ClientAnchor(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.ClientAnchor');
      this.j = jObj;
    end
    
    function out = get.anchorType(this)
      out = jl.office.excel.ClientAnchorType.ofJava(this.j.getAnchorType);
    end
    
    function set.anchorType(this, val)
      mustBeA(val, 'jl.office.excel.ClientAnchorType');
      this.j.setAnchorType(val.j);
    end
    
    function out = get.col1(this)
      out = this.j.getCol1;
    end
    
    function set.col1(this, val)
      this.j.setCol1(val);
    end
    
    function out = get.col2(this)
      out = this.j.getCol2;
    end
    
    function set.col2(this, val)
      this.j.setCol2(val);
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
    
    function out = get.row1(this)
      out = this.j.getRow1;
    end
    
    function set.row1(this, val)
      this.j.setRow1(val);
    end
    
    function out = get.row2(this)
      out = this.j.getRow2;
    end
    
    function set.row2(this, val)
      this.j.setRow2(val);
    end
    
  end
  
end

