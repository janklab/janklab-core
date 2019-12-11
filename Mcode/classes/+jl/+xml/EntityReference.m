classdef EntityReference < jl.xml.Node
  % EntityReference A reference to a (non-predefined) XML entity
  %
  % This is currently unimplemented because it seems pretty hard, and I'm
  % not sure what the right interface for it is.
  
  methods
    function this = EntityReference(varargin)
     error('jl:Unimplemented', "XML EntityReferences are currently unimplemented. Sorry.");
    end
  end
  
end  