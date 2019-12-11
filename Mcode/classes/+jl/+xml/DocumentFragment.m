classdef DocumentFragment < jl.xml.Node
  
  methods
  end
  
  methods (Access = protected)
    function out = getName(this)
      out = "#document-fragment";
    end
    
  end
  
end