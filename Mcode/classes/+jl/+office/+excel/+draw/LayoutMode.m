classdef LayoutMode < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    Edge(org.apache.poi.ss.usermodel.charts.LayoutMode.EDGE)
    Factor(org.apache.poi.ss.usermodel.charts.LayoutMode.FACTOR)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.LayoutMode.EDGE)
        out = jl.office.excel.draw.LayoutMode.Edge;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.LayoutMode.FACTOR)
        out = jl.office.excel.draw.LayoutMode.Factor;
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
    
    function this = LayoutMode(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.LayoutMode');
      this.j = jObj;
    end
  
  end
  
end