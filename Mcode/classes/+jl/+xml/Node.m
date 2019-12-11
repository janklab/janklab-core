classdef Node < handle & matlab.mixin.Heterogeneous & jl.util.DisplayableHandle
  % Node Generic interface for a node in an XML document
  %
  % Elements, text, and attributes are all Nodes, and they are arranged in
  % a tree structure that uses the generic Node type for all nodes in the
  % tree.
  %
  % Note that Node is a handle class. This is needed to support
  % back-references to the Node's parent Node and owner Document, which are
  % not possible with normal pass-by-value objects.
  
  % TODO: Prefix support
  % TODO: Index/sibling navigation
  % TODO: Namespace support
  % TODO: normalize()
  % TODO: clone()
  % TODO: XPath selection support
  
  %#ok<*MANU>
  %#ok<*INUSL>
  
  properties (Dependent)
    name
    value
    % The owner Document that this node is contained in
    document
  end

  properties
    % Children of this node
    % This *should* be enforced to be a jl.xml.Node array, but that would
    % cause a circular dependency in construction.
    children = [];
  end

  properties (GetAccess = public, SetAccess = protected)
    % The immediate parent node of this node
    % Must be a scalar Node or empty.
    % This *should* be enforced to be a jl.xml.Node array, but that would
    % cause a circular dependency in construction.
    parent = []
    % The index of this node in the children list of its parent
    index double = NaN
  end
  
  properties (Access = protected)
    document_
  end

  methods (Static)
    function out = empty()
      out = repmat(jl.xml.Node, [0 0]);
    end
  end
  
  methods
    function out = get.value(this)
      out = this.getValue();
    end
    
    function set.parent(this, parent)
      mustBeA(parent, 'jl.xml.Node');
      if ~isempty(parent)
        mustBeScalar(parent);
      end
      this.parent = parent;
    end
    
    function set.children(this, children)
      this.validateChildren(children);
      this.children = children;
      % Update references! Putting a Node in another Node's child array
      % transfers ownership of that node
      for i = 1:numel(this.children)
        this.children(i).index = i;
        this.children(i).parent = this;
      end
    end
        
    function out = get.name(this)
      out = this.getName();
    end
    
    function set.name(this, name)
      this.setName(name);
    end
    
    function out = get.document(this)
      out = this.getOwnerDocument();
    end
    
    function out = getAttributes(this)
      out = jl.xml.Attr.empty;
    end
    
    function out = dumpText(this)
      strs = arrayfun(@(x) dumpText_scalar(x), this);
      out = strjoin(strs, "");
    end
    
    function out = prettyprint(this, opts)
      % prettyprint Print in a nicely-formatted human-readable manner
      %
      % opts (jl.xml.PrettyPrintOptions) controls the display behavior.
      %
      % See also:
      % jl.xml.PrettyPrintOptions
      if nargin < 2 || isempty(opts); opts = {}; end
      opts = jl.xml.PrettyPrintOptions(opts);
      str = prettyprint_step(this, 0, opts);
      if nargout == 0
        % Display as char because I don't like the extra indentation that
        % displaying a string array gives you
        disp(char(str));
      else
        out = str;
      end
    end
  end
  
  methods (Access = protected)
    function out = getName(this)
      out = '<no name>';
    end
    
    function out = getValue(this)
      out = [];
    end
    
    function out = getChildren(this)
      out = jl.xml.Node.empty;
    end
    
    function out = getOwnerDocument(this)
      out = this.document_;
    end
    
    function validateChildren(this, children)
      mustBeA(children, 'jl.xml.Node');
      % The generic Node type does no further validation. That's left up to
      % the subclasses.
    end
    
    function out = dumpText_scalar(this) %#ok<STOUT>
      error('jl:Unimplemented', ['Subclasses of Node must override ' ...
        'dumpText_scalar(); %s does not'], class(this));
    end
    
    function out = dispstr_scalar(this)
      type = regexprep(class(this), '.*\.', '');
      out = sprintf("XML %s name='%s'", type, this.name);
      extra = string.empty;
      if ~isempty(this.children)
        extra(end+1) = sprintf("%d children", numel(this.children));
      end
      if ~isempty(extra)
        out = sprintf("%s (%s)", out, strjoin(extra, ", "));
      end
    end
    
    function out = prettyprint_step(this, depth, opts) %#ok<INUSD,STOUT>
      error('jl:Unimplemented', ['Subclasses of Node must override ' ...
        'prettyprint_step(); %s does not'], class(this));
    end
  end
end
