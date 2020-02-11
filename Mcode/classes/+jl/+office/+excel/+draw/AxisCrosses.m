classdef AxisCrosses < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    AutoZero(org.apache.poi.ss.usermodel.charts.AxisCrosses.AUTO_ZERO)
    Max(org.apache.poi.ss.usermodel.charts.AxisCrosses.MAX)
    Min(org.apache.poi.ss.usermodel.charts.AxisCrosses.MIN)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisCrosses.AUTO_ZERO)
        out = jl.office.excel.draw.AxisCrosses.AutoZero;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisCrosses.MIN)
        out = jl.office.excel.draw.AxisCrosses.Min;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisCrosses.MAX)
        out = jl.office.excel.draw.AxisCrosses.Max;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      out = this.j;
    end
    
  end
  
  methods (Access = private)
    
    function this = AxisCrosses(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.AxisCrosses');
      this.j = jObj;
    end
  
  end
  
end