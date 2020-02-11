classdef LayoutTarget < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Inner(org.apache.poi.ss.usermodel.charts.LayoutTarget.INNER)
    Outer(org.apache.poi.ss.usermodel.charts.LayoutTarget.OUTER)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.LayoutTarget.INNER)
        out = jl.office.excel.draw.LayoutTarget.Inner;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.LayoutTarget.OUTER)
        out = jl.office.excel.draw.LayoutTarget.Outer;
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
    
    function this = LayoutTarget(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.LayoutTarget');
      this.j = jObj;
    end
  
  end
  
end