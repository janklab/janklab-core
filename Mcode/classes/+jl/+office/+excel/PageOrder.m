classdef PageOrder
  %PAGEORDER
  
  properties
    j
  end
  
  enumeration
    DownThenOver(org.apache.poi.ss.usermodel.PageOrder.DOWN_THEN_OVER)
    OverThenDown(org.apache.poi.ss.usermodel.PageOrder.OVER_THEN_DOWN)
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.PageOrder.DOWN_THEN_OVER)
        out = jl.office.excel.PageOrder.DownThenOver;
      elseif jObj.equals(org.apache.poi.ss.usermodel.PageOrder.OVER_THEN_DOWN)
        out = jl.office.excel.PageOrder.OverThenDown;
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
    
    function this = PageOrder(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.PageOrder');
      this.j = jObj;
    end
    
  end
  
end

