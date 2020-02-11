classdef TitleType < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    CellReference(org.apache.poi.ss.usermodel.charts.TitleType.CELL_REFERENCE)
    String(org.apache.poi.ss.usermodel.charts.TitleType.STRING)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.TitleType.CELL_REFERENCE)
        out = jl.office.excel.draw.TitleType.CellReference;
      elseif jObj.equals(org.apache.poi.ss.usermodel.charts.TitleType.STRING)
        out = jl.office.excel.draw.TitleType.String;
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
    
    function this = TitleType(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.TitleType');
      this.j = jObj;
    end
  
  end
  
end