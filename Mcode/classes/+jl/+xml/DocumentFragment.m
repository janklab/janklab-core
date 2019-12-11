classdef DocumentFragment < jl.xml.Node
  % DocumentFragment A fragment of an XML document
  
  %#ok<*MANU>
  
  methods
  end
  
  methods (Access = protected)
    function out = getName(this)
      out = "#document-fragment";
    end
    
  end
  
end