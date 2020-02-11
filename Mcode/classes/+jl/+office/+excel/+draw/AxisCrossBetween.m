classdef AxisCrossBetween < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Between(org.apache.poi.ss.usermodel.charts.AxisCrossBetween.BETWEEN)
    MidpointCategory(org.apache.poi.ss.usermodel.charts.AxisCrossBetween.MIDPOINT_CATEGORY)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisCrossBetween.BETWEEN)
        out = jl.office.excel.draw.AxisCrossBetween.Between;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisCrossBetween.MIDPOINT_CATEGORY)
        out = jl.office.excel.draw.AxisCrossBetween.MidpointCategory;
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
    
    function this = AxisCrossBetween(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.AxisCrossBetween');
      this.j = jObj;
    end
  
  end
  
end