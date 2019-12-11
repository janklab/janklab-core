classdef Text < jl.xml.Node
  % Text Textual content of an Element or Attr
  
  % TODO: Escape pretty-printed text with XML entities
  
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
    
    function out = isIgorableWhitespace(this)
      % isIgnorableWhitespace
      %
      % NOTE: This is a HACK! It doesn't correspond to something that's
      % really defined in the XML spec. Use at your own risk.
      out = false(size(this));
      for i = 1:numel(this)
        out(i) = ~isempty(regexp(this(i).text, '^\s*$', 'once'));
      end
    end
  end
  
  methods (Access = protected)
    function out = dispstr_scalar(this)
      out = sprintf("XML Text: '%s'", this.text);
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
    
    function out = prettyprint_step(this, depth, opts)
      mustBeScalar(this);
      if depth <= opts.expandDepth
        indent = repmat('  ', [1 depth]);
      else
        indent = '';
      end
      if depth >= opts.expandDepth
        if this.isIgorableWhitespace
          out = "";
        else
          out = strrep(this.text, sprintf('\r'), '\r');
          out = strrep(out, sprintf('\n'), '\n'); %#ok<SPRINTFN>
        end
      else
        out = sprintf("%s%s", indent, this.text);
      end
    end
    
    function out = getName(this) %#ok<MANU>
      out = "#text";
    end
  end
  
end
