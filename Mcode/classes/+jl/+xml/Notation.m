classdef Notation < jl.xml.Node
  % Notation A notation declared in the DTD
  %
  
  properties
    publicId string = jl.xml.Util.missing_string;
    systemId string = jl.xml.Util.missing_string;
  end
  
  methods
    function this = Notation(varargin)
      % Notation construct a new notation
      %
      % Notation(publicId, systemId)
      % Notation(doc, publicId, systemId)
      %
      % TODO: This is probably incomplete because there's no way to specify
      % its child contents?
      
      narginchk(0, 1);
      if isempty(varargin)
        return;
      end
      args = varargin;
      if isa(args{1}, 'jl.xml.Document')
        this.document_ = args{1};
        args(1) = [];
      end
      if numel(args) >= 1
        this.publicId = args{1};
      end
      if numel(args) >= 2
        this.systemId = args{2};
      end
    end
  end
end
