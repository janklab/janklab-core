classdef Document < jl.xml.Node
  % Document An XML document
  
  % TODO: Support empty/unspecified xmlEncoding and xmlVersion
  
  %#ok<*MANU>
  
  properties
    documentType jl.xml.DocumentType = jl.xml.DocumentType.nil
    documentURI string = jl.xml.Util.missing_string
    xmlEncoding string = "UTF-8"
    xmlStandalone logical = false
    xmlVersion string = "1.0"
  end
  
  properties (Access = private)
  end
  
  properties (Dependent)
    % The root or "document" node of this document. This is just a
    % convenience getter which gets the single child node of this document.
    % It will always be an Element, or empty.
    rootNode
  end
  
  methods
    function this = Document()
    end
    
    function out = get.rootNode(this)
      if isempty(this.children)
        out = jl.xml.Node.empty;
      else
        out = this.children(1);
      end
    end
    
    function set.rootNode(this, node)
      this.children = node;
    end
    
end
  
  % Factory methods
  methods
    function out = createAttribute(this, varargin)
      out = jl.xml.Attr(this, varargin{:});
    end
    
    function out = createComment(this, varargin)
      out = jl.xml.Comment(this, varargin{:});
    end
    
    function out = createElement(this, name)
      out = jl.xml.Element(this, name);
    end
  end
  
  methods (Access = protected)
    
    function out = getOwnerDocument(this)
      out = this;
    end
    
    function out = getName(this)
      out = "#document";
    end
    
    function out = dispstr_scalar(this)
      if isempty(this.rootNode)
        rootNodeDesc = "null root node";
      else
        rootNodeDesc = sprintf("rootNode=%s", this.rootNode.name);
      end
      out = sprintf("XML Document (%s)", rootNodeDesc);
    end
    
    function validateChildren(this, children)
      validateChildren@jl.xml.Node(this, children);
      if numel(children) > 1
        error('A Document can only have 1 child node; got %d', numel(children));
      end
      if ~isempty(children)
        if ~isa(children, 'jl.xml.Element')
          error('The root node of a Document must be an Element; got a %s', ...
            class(children));
        end
      end
    end
    
    function out = xmlHeaderStr(this)
      mustBeScalar(this);
      standaloneStr = "";
      if this.xmlStandalone
        standaloneStr = "standalone=""yes""";
      end
      out = sprintf("<?xml version=""%s"" encoding=""%s"" %s?>", ...
          this.xmlVersion, this.xmlEncoding, standaloneStr);
    end
    
    function out = dumpText_scalar(this)
      s = sprintf("%s\n", this.xmlHeaderStr);
      if ~isnil(this.documentType)
        s = s + this.documentType.dumpText + newline;
      end
      s = s + this.rootNode.dumpText;
      out = s;
    end
    
    function out = prettyprint_step(this, indentLevel, opts) %#ok<INUSL>
      % Ignore indentLevel because Documents are always root level
      s = sprintf("%s\n", this.xmlHeaderStr);
      if ~isnil(this.documentType)
        s = s + this.documentType.dumpText + newline;
      end
      s = s + this.rootNode.prettyprint(opts);
      out = s;
    end
end
end