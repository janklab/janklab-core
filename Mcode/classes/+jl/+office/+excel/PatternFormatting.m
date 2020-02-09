classdef PatternFormatting < handle
  %
  
  properties
    j
  end

  properties (Dependent)
    fillBackgroundColor
    fillForegroundColor
    fillPattern
  end
  
  methods
    
    function this = PatternFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.hssf.usermodel.HSSFConditionalFormattingRule');
      this.j = jObj;
    end
    
    function out = get.fillBackgroundColor(this)
      out = jl.office.excel.Color(this.j.getFillBackgroundColorColor);
    end
    
    function set.fillBackgroundColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setFillBackgroundColor(val.j);
    end
    
    function out = get.fillForegroundColor(this)
      out = jl.office.excel.Color(this.j.getFillForegroundColorColor);
    end
    
    function set.fillForegroundColor(this, val)
      mustBeA(val, 'jl.office.excel.Color');
      this.j.setFillForegroundColor(val.j);
    end
    
    function out = get.fillPattern(this)
      out = jl.office.excel.FillPattern.ofJava(this.j.getFillPattern);
    end
    
    function set.fillPattern(this, val)
      mustBeA(val, 'jl.office.excel.FillPattern');
      this.j.setFillPattern(val.toJava);
    end
    
  end
  
end

