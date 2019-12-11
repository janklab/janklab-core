classdef DocumentType < handle
  % DocumentType A basic representation of an XML document type.
  %
  % DocumentType provides a list of defined entities, and not much else,
  % because the effect of namespaces and the various  XML schema efforts on
  % DTD representation are not clearly understood as of this writing.

  %#ok<*MANU>
  
  % TODO: Enforce types in the field Maps
  
  methods (Static)
    function out = nil
      out = jl.xml.DocumentType;
    end
  end
  
  properties (Access = private)
    isNil logical = true
  end
  
  properties
    name string = string(missing)
    publicId string = string(missing)
    systemId string = string(missing)
    internalSubset string = string(missing)
    entities containers.Map = containers.Map
    notations containers.Map = containers.Map
  end
  
  methods
    function out = DocumentType()
      % DocumentType Construct a new DocumentType
      %
      % Note: DocumentType is currently mostly unimplemented, and we currently
      % only support a nil value for it.
    end
    
    function out = isnil(this)
      out = this.isNil;
    end
  end
  
end