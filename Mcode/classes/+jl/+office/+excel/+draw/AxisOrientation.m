classdef AxisOrientation < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    MaxMin(org.apache.poi.ss.usermodel.charts.AxisOrientation.MAX_MIN)
    MinMax(org.apache.poi.ss.usermodel.charts.AxisOrientation.MIN_MAX)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisOrientation.MAX_MIN)
        out = jl.office.excel.draw.AxisOrientation.MaxMin;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisOrientation.MIN_MAX)
        out = jl.office.excel.draw.AxisOrientation.MinMax;
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
    
    function this = AxisOrientation(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.AxisOrientation');
      this.j = jObj;
    end
  
  end
  
end