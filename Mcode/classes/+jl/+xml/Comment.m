classdef Comment < jl.xml.Node
  % Comment An XML comment
  %
  % Represents an XML comment (those things represented as "<!-- ... -->"
  % in the XML text.
  
  properties (Access = private)
    text_ {mustBeScalarString} = ""
  end
  
  methods
    function this = Comment(varargin)
      %
      % Comment(str)
      % Comment(ownerDocument, str)
      %
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
    
    function out = dumpText(this)
      out = sprintf("XML Comment: <--%s-->", this.text_);
    end
  end
  
  methods (Access = protected)
    function out = getName(this) %#ok<MANU>
      out = "#comment";
    end
    
    function out = dispstr_scalar(this)
      out = sprintf("<--%s-->", this.text_);
    end
    
    function validateChildren(this, children)
      validateChildren@jl.xml.Node(this, children);
      if ~isempty(children)
        error('Comment nodes do not allow children');
      end
    end

    function out = prettyprint_step(this, indentLevel, opts)
      indent = repmat('  ', [1 indentLevel]);
      out = sprintf("%s<!-- %s -->\n", indent, this.text_);
    end
  end
  
end
