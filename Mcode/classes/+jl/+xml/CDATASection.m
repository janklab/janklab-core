classdef CDATASection < jl.xml.Node
% CDATASection a CDATA section of escaped text
%

  % TODO: Validation: make sure contents don't include "]]"
  
  properties
    text {mustBeScalarString} = ""
  end
  
  methods
    function this = CDATASection(varargin)
      % CDATASection construct a new CDATASection node
      %
      % CDATASection(str)
      % CDATASection(ownerDocument, str)
      narginchk(0, 2);
      if isempty(varargin)
        return;
      end
      args = varargin;
      if isa(args{1}, 'jl.xml.Document')
        this.document_ = args{1};
        args(1) = [];
      end
      if numel(args) > 0
        this.text_ = args{1};
      end
    end
    
  end
  
  methods (Access = protected)
    function out = dispstr_scalar(this)
      out = sprintf("<![CDATA[[%s]]>", this.text);
    end
    
    function validateChildren(this, children)
      validateChildren@jl.xml.Node(this, children);
      if ~isempty(children)
        error('CDATASection nodes do not allow children');
      end
    end
    
    function out = dumpText_scalar(this)
      mustBeScalar(this);
      out = sprintf("<![CDATA[[%s]]>", this.text);
    end
  end
  
end
