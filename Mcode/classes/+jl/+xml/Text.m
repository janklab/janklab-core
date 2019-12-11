classdef Text < jl.xml.Node
  % Text Textual content of an Element or Attr
  
  properties
    text {mustBeScalarString} = ""
  end

  methods
    function this = Text(varargin)
      % Text construct a new Text node
      %
      % Text(str)
      % Text(ownerDocument, str)
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
        this.text = string(args{1});
      end
    end    
  end
  
  methods (Access = protected)
    function out = dispstr_scalar(this)
      out = sprintf("Text: '%s'", this.text);
    end
    
    function validateChildren(this, children)
      validateChildren@jl.xml.Node(this, children);
      if ~isempty(children)
        error('Text nodes do not allow children');
      end
    end
    
    function out = dumpText_scalar(this)
      out = this.text;
    end
    
    function out = prettyprint_step(this, indentLevel, opts) %#ok<INUSD>
      indent = repmat('  ', [1 indentLevel]);
      out = sprintf("%s%s", indent, this.text);
    end
    
    function out = getName(this) %#ok<MANU>
      out = "#text";
    end
  end
  
end
