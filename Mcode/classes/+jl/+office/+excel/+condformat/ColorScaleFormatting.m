classdef (Abstract) ColorScaleFormatting < handle
  %COLORSCALEFORMATTING 
  
  properties
    j
  end
  
  properties (Dependent)
    colors
    numControlPoints
    thresholds
  end
  
  
  methods
    
    function this = ColorScaleFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.ColorScaleFormatting');
      this.j = jObj;
    end
    
    function out = get.colors(this)
      out = jl.office.excel.Color(this.j.getColors);
    end
    
    function set.colors(this, colors)
      mustBeA(colors, 'jl.office.excel.Color');
      this.j.setColors(colors.toJavaArray);
    end
    
    function out = get.numControlPoints(this)
      out = this.j.getNumControlPoints;
    end
    
    function set.numControlPoints(this, val)
      this.j.setNumControlPoints(val);
    end
    
    function out = get.thresholds(this)
      out = this.wrapConditionalFormattingThresholdObject(this.j.getThresholds);
    end
    
    function set.thresholds(this, val)
      mustBeA(val, 'jl.office.excel.condformat.ConditionalFormattingThresholdRangeType');
      this.j.setThresholds(val.toJavaArray);
    end
    
    function out = createThreshold(this)
      out = this.wrapConditionalFormattingThresholdObject(this.j.createThreshold);
    end
    
  end
  
  methods (Abstract, Access = protected)
    out = wrapConditionalFormattingThresholdObject(this, jObj)
  end
  
end

