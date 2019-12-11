classdef DocumentType < handle
  % DocumentType A basic representation of an XML document type.
  %
  % DocumentType provides a list of defined entities, and not much else,
  % because the effect of namespaces and the various  XML schema efforts on
  % DTD representation are not clearly understood as of this writing.

  %#ok<*MANU>
  
  % TODO: Convert this to be a Node
  % TODO: Enforce types in the field Maps
  % TODO: publicId, systemId, entities, and notations in text output
  
  methods (Static)
    function out = nil
      out = jl.xml.DocumentType;
      out.isNil = true;
    end
  end
  
  properties (Access = private)
    isNil logical = false
  end
  
  properties
    name string = string(missing)
    publicId string = string(missing)
    systemId string = string(missing)
    internalSubset string = ""
    entities containers.Map = containers.Map
    notations containers.Map = containers.Map
  end
  
  methods
    function out = DocumentType()
      % DocumentType Construct a new DocumentType
      %
      % Note: DocumentType is currently mostly unimplemented. Careful with
      % it. You may just lose data if you depend on it in its current form.
    end
    
    function out = isnil(this)
      out = this.isNil;
    end
    
    function out = dumpText(this)
      % dumpText
      %
      % TODO: I don't know what to do with publicId, systemId, entities,
      % or notations here.
      s = sprintf("<!DOCTYPE %s [\n", this.name);
      s = s + this.internalSubset;
      s = s + "]>";
      out = s;
    end
  end
  
  methods (Access = protected)
    function out = getName(this)
      out = this.name;
    end
  end
  
end