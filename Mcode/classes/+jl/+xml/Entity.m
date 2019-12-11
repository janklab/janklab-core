classdef Entity < jl.xml.Node
  % Entity An XML entity
  
  % Developer's note:
  % This implementation seems really slow and heavyweight,
  % especially since entities are not editable in DOM level 3.
  %
  % Really, this is bad because we're creating new entity objects for every
  % entity we encounter in a document; we ought to be using references to
  % shared flyweight objects for each unique entity value instead.
  % But I'm not sure exactly which values it should be canonicalizing on,
  % so I'll leave that for later.
  
  %#ok<*NASGU>
  
  % Should enforce that these properties are scalars, too.
  properties
    inputEncoding string = jl.xml.Util.missing_string;
    notationName string = jl.xml.Util.missing_string;
    publicId string = jl.xml.Util.missing_string;
    systemId string = jl.xml.Util.missing_string;
    xmlEncoding string = jl.xml.Util.missing_string;
    xmlVersion string = jl.xml.Util.missing_string;
  end
  
  methods
    function this = Entity(varargin)
      narginchk(0, 1);
      if isempty(varargin)
        return;
      end
      args = varargin;
      if isa(args{1}, 'jl.xml.Document')
        this.document_ = args{1};
        args(1) = [];
      end
    end
  end
  
  methods (Access = protected)
    function out = getName(this) %#ok<STOUT,MANU>
      % TODO: Fix this
      error('jl:Unimplemented', 'jl.xml.Entity.getName() is unimplemented')
    end    
  end
end