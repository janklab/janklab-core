classdef AxisPosition < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Bottom(org.apache.poi.ss.usermodel.charts.AxisPosition.BOTTOM)
    Left(org.apache.poi.ss.usermodel.charts.AxisPosition.LEFT)
    Right(org.apache.poi.ss.usermodel.charts.AxisPosition.RIGHT)
    Top(org.apache.poi.ss.usermodel.charts.AxisPosition.TOP)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisPosition.BOTTOM)
        out = jl.office.excel.draw.AxisPosition.Bottom;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisPosition.LEFT)
        out = jl.office.excel.draw.AxisPosition.Left;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisPosition.RIGHT)
        out = jl.office.excel.draw.AxisPosition.Right;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisPosition.TOP)
        out = jl.office.excel.draw.AxisPosition.Top;
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
    
    function this = AxisPosition(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.AxisPosition');
      this.j = jObj;
    end
  
  end
  
end