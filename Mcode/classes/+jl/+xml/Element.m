classdef Element < jl.xml.Node
  % Element An XML element
  
  % TODO: We *should* enforce that any children of this element have the
  % same owner document as this.
  
  %#ok<*NASGU>
  %#ok<*AGROW>

  properties (Constant, Hidden)
    allowedChildTypes = ["jl.xml.Element", "jl.xml.Comment", ...
      "jl.xml.Text"];
  end
  
  properties
    attributes jl.xml.Attr = jl.xml.Attr.empty
  end
  
  properties (Access = protected)
    name_ {mustBeScalarString} = ""
  end
  
  methods
    function this = Element(varargin)
      % Element Construct a new Element
      %
      % Element()
      % Element(name)
      % Element(ownerDocument, name)
      narginchk(0, 2);
      if nargin == 0
        return
      end
      args = varargin;
      if isa(args{1}, 'jl.xml.Document')
        this.document_ = args{1};
        args(1) = [];
      end
      if numel(args) >= 1
        this.name_ = args{1};
      end
    end
    
    function out = getAttributes(this)
      out = this.attributes;
    end
    
    % TODO: Attribute access convenience methods
  end
  
  methods (Access = protected)
    
    function out = getName(this)
      out = this.name_;
    end
    
    function setName(this, name)
      this.name_ = name;
    end
    
    function validateChildren(this, children)
      validateChildren@jl.xml.Node(this, children);
      okTypes = jl.xml.Element.allowedChildTypes;
      for i = 1:numel(children)
        ok = false;
        for iType = 1:numel(okTypes)
          if isa(children(i), okTypes(iType))
            ok = true;
            break;
          end
        end
        if ~ok
          error("%s does not allow child nodes of type %s", ...
            class(this), class(children(i)));
        end
      end
    end
    
    function out = dispstr_scalar(this)
      type = regexprep(class(this), '.*\.', '');
      out = sprintf("XML %s <%s>", type, this.name);
      extra = string.empty;
      if ~isempty(this.children)
        extra(end+1) = sprintf("%d children", numel(this.children));
      end
      if ~isempty(this.attributes)
        extra(end+1) = sprintf("%d attributes", numel(this.attributes));
      end
      if ~isempty(extra)
        out = sprintf("%s (%s)", out, strjoin(extra, ", "));
      end
    end
    
    function out = tagText(this)
      mustBeScalar(this);
      attrStrs = strjoin(dispstrs(this.attributes), " ");
      if isempty(attrStrs)
        out = this.name;
      else
        out = sprintf("%s %s", this.name, attrStrs);
      end
    end
    
    function out = dumpText_scalar(this)
      if isempty(this.children)
        out = sprintf("<%s/>", this.tagText);
      else
        kidStrs = repmat(string(missing), size(this.children));
        for i = 1:numel(this.children)
          kidStrs(i) = this.children(i).dumpText;
        end
        out = sprintf("<%s>%s</%s>", this.tagText, ...
          strjoin(kidStrs, ""), this.name);
      end
    end
    
    function out = prettyprint_step(this, depth, opts)
      
      if depth <= opts.expandDepth
        indent = repmat('  ', [1 depth]);
      else
        indent = '';
      end
      if depth < opts.expandDepth
        lineEnd = newline;
      else
        lineEnd = '';
      end

      % Special tag text
      attrStrs = repmat("", size(this.attributes));
      for i = 1:numel(this.attributes)
        attrStrs(i) = sprintf("%s = ""%s""", this.attributes(i).name, ...
          this.attributes(i).value);
      end
      if isempty(attrStrs)
        tagText = this.name;
      else
        if opts.attrsOnSeparateLines && numel(attrStrs) > 1
          s = sprintf("%s", this.name);
          for i = 1:numel(attrStrs)
            s = s + newline + indent + "    " + attrStrs(i);
          end
          tagText = s;
        else
          tagText = sprintf("%s %s", this.name, strjoin(attrStrs, " "));
        end
      end
      
      if isempty(this.children)
        out = sprintf("%s<%s/>%s", indent, tagText, lineEnd);
      elseif isscalar(this.children) && isa(this.children, 'jl.xml.Text')
        out = sprintf("%s<%s>%s</%s>%s", indent, tagText, ...
          this.children(1).text, this.name, lineEnd);
      else
        s = string.empty;
        for i = 1:numel(this.children)
          child_str = prettyprint_step(this.children(i), depth + 1, opts);
          s(end+1) = child_str;
        end
        if depth < opts.expandDepth
          out = sprintf("%s<%s>\n%s%s</%s>\n", indent, tagText, ...
            strjoin(s, ""), indent, this.name);
        else
          out = sprintf("<%s>%s</%s>", tagText, strjoin(s, ""), this.name);
        end
      end
    end
  end
end