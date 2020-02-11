classdef ChartLegend
  %CHARTLEGEND
  
  properties
    j
  end
  
  methods
    
    function this = ChartLegend(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.ChartLegend');
      this.j = jObj;
    end
    
    function out = getPosition(this)
      out = jl.office.excel.draw.LegendPosition(this.j.getPosition);
    end
    
    function out = isOverlay(this)
      out = this.j.isOverlay;
    end
    
    function setOverlay(this, val)
      this.j.setOverlay(val);
    end
    
    function setPosition(this, val)
      mustBeA(val, 'jl.office.excel.draw.LegendPosition');
      this.j.setPosition(val.j);
    end
    
  end
  
end

