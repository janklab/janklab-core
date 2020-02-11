classdef AxisTickMark < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Cross(org.apache.poi.ss.usermodel.charts.AxisTickMark.CROSS)
    In(org.apache.poi.ss.usermodel.charts.AxisTickMark.IN)
    None(org.apache.poi.ss.usermodel.charts.AxisTickMark.NONE)
    Out(org.apache.poi.ss.usermodel.charts.AxisTickMark.OUT)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisTickMark.CROSS)
        out = jl.office.excel.draw.AxisTickMark.Cross;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisTickMark.IN)
        out = jl.office.excel.draw.AxisTickMark.In;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisTickMark.NONE)
        out = jl.office.excel.draw.AxisTickMark.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.AxisTickMark.OUT)
        out = jl.office.excel.draw.AxisTickMark.Out;
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
    
    function this = AxisTickMark(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.AxisTickMark');
      this.j = jObj;
    end
  
  end
  
end