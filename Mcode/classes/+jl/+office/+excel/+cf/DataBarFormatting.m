classdef DataBarFormatting < handle
  %DATABARFORMATTING
  
  properties
    j
  end
  
  properties (Dependent)
    color
    maxThreshold
    minThreshold
    widthMax
    widthMin
    isIconOnly
    isLeftToRight
  end
  
  methods
    
    function this = DataBarFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.DataBarFormatting');
      this.j = jObj;
    end
    
    function out = get.color(this)
      out = jl.office.excel.Color(this.j.getColor);
    end
    
    function set.color(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setColor(val.j);
    end
    
    function out = get.maxThreshold(this)
      out = jl.office.excel.cf.ConditionalFormattingThreshold(this.j.getMaxThreshold);
    end
    
    function out = get.minThreshold(this)
      out = jl.office.excel.cf.ConditionalFormattingThreshold(this.j.getMinThreshold);
    end
    
    function out = get.widthMax(this)
      out = this.j.getWidthMax;
    end
    
    function set.widthMax(this, val)
      this.j.setWidthMax(val);
    end
    
    function out = get.widthMin(this)
      out = this.j.getWidthMin;
    end
    
    function set.widthMin(this, val)
      this.j.setWidthMin(val);
    end
    
    function out = get.isIconOnly(this)
      out = this.j.isIconOnly;
    end
    
    function set.isIconOnly(this, val)
      this.j.setIconOnly(val);
    end
    
    function out = get.isLeftToRight(this)
      out = this.j.isLeftToRight;
    end
    
    function set.isLeftToRight(this, val)
      this.j.setLeftToRight(val);
    end
    
  end
  
end

