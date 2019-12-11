classdef CDATASection < jl.xml.Node
% CDATASection a CDATA section of non-parsed text
%
  
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
    
    function set.text(this, text)
      ix = strfind(text, "]]");
      if ~isempty(ix)
        error(['CDATASection text may not contain the string '']]''. ' ...
          'Input contains it at indexes %s'], mat2str(ix));
      end
      this.text = text;
    end
    
  end
  
  methods (Access = protected)
    function out = getName(this) %#ok<MANU>
      out = "#cdata-section";
    end
    
    function out = dispstr_scalar(this)
      out = sprintf("XML CDATASection: <![CDATA[[%s]]>", this.text);
    end
    
    function validateChildren(this, children)
      validateChildren@jl.xml.Node(this, children);
      if ~isempty(children)
        error('CDATASection nodes do not allow children');
      end
    end
    
    function out = dumpText_scalar(this)
      mustBeScalar(this);
      out = sprintf("<![CDATA[%s]]>", this.text);
    end
    
    function out = prettyprint_step(this, indentLevel, opts) %#ok<INUSD>
      mustBeScalar(this);
      indent = repmat('  ', [1 indentLevel]);
      out = sprintf("%s<![CDATA[%s]]>\n", indent, this.text);
    end
  end
  
end
