classdef Element < jl.xml.Node
  % Element An XML element
  
  % TODO: We *should* enforce that any children of this element have the
  % same owner document as this.
  
  %#ok<*NASGU>
  
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
  
  methods (Static)
    function out = ofJavaDom(doc, jnode)
      % ofJavaDom Convert a Java DOM object to an Element
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.Element');
      out = jl.xml.Element(doc, string(jnode.getNodeName));
    end
  end
  
  methods
    function this = Element(varargin)
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
      out = sprintf("%s <%s>", type, this.name);
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
  end
end