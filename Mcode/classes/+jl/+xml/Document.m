classdef Document < jl.xml.Node
  
  %#ok<*MANU>
  
  properties
    documentType jl.xml.DocumentType = jl.xml.DocumentType.nil;
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
      out = sprintf("Document (%s)", rootNodeDesc);
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
    
  end
end