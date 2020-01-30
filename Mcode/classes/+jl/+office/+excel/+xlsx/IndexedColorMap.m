classdef IndexedColorMap < jl.util.DisplayableHandle
  
  properties (SetAccess = private)
    % The underlying org.apache.poi.xssf.usermodel.IndexedColorMap Java object
    j
  end
  
  methods
    
    function this = IndexedColorMap(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.IndexedColorMap');
      this.j = jObj;
    end
    
    function out = getRgb(this, index)
      out = this.j.getRGB(index);
    end
    
  end
  
end