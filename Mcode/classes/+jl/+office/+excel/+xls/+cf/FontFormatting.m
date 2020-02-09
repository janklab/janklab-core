classdef FontFormatting < jl.office.excel.cf.FontFormatting
  %FONTFORMATTING XLS-specific font formatting
  
  properties (Dependent)
    fontWeight
    outline
    shadow
    struckout
  end
  
  methods
    
    function this = FontFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.hssf.usermodel.XSSFFontFormatting');
      this.j = jObj;
    end
    
    function out = get.fontWeight(this)
      out = this.j.getFontWeight;
    end
    
    function out = get.outline(this)
      out = this.j.isOutlineOn;
    end
    
    function set.outline(this, val)
      this.j.setOutline(val);
    end
    
    function out = get.shadow(this)
      out = this.j.isShadowOn;
    end
    
    function set.shadow(this, val)
      this.j.setShadow(val);
    end
    
    function out = get.struckout(this)
      out = this.j.isStruckout;
    end
    
    function set.struckout(this, val)
      this.j.setStrikeout(val);
    end
    
  end
  
  methods (Access = protected)
  
    function setIsStruckout(this, val)
      this.j.setStrikeout(val);
    end
    
  end
  
end
