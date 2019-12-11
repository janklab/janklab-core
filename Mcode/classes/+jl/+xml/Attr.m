classdef Attr < jl.xml.Node
  % Attr An XML attribute
  
  % TODO: Enforce that parent node, if present, is an Element
  
  %#ok<*MANU>

  properties (Access = protected)
    name_ {mustBeScalarString} = ""
    value_ {mustBeScalarString} = ""
  end
  
  methods (Static)
    function out = empty
      out = repmat(jl.xml.Attr, [0 0]);
    end
  end
  
  methods
    function this = Attr(varargin)
      % Attr Construct a new Attr node
      %
      % Attr(name, value)
      % Attr(parentElement, name, value)
      narginchk(0, 3);
      if isempty(varargin)
        return;
      end
      args = varargin;
      if isa(args{1}, 'jl.xml.Element')
        this.parent = args{1};
        args(1) = [];
      end
      if isa(args{1}, 'jl.xml.Document')
        error('jl:InvalidInput', 'Attr() takes an Element parent, not a Document!');
      end
      if numel(args) > 2
        error('Invalid argument count!');
      end
      if numel(args) >= 1
        this.name_ = args{1};
      end
      if numel(args) > 1
        this.value_ = args{2};
      end
    end
    
    function set.name_(this, name)
      mustBeScalarString(name);
      ok = jl.xml.Util.isValidXmlName(name);
      if ~ok
        error('Invalid attribute name: ''%s''', name);
      end
      this.name_ = name;
    end
    
  end
  
  methods (Access = protected)
    function out = getName(this)
      out = this.name_;
    end
    
    function out = getValue(this)
      out = this.value_;
    end
    
    function out = getOwnerDocument(this)
      % Attrs are a special case in that they are not considered to have an
      % owner document, only a parent Element.
      out = [];
    end
    
    function out = dispstr_scalar(this)
      if isempty(this.name_)
        out = '<null Attr>';
      else
        out = sprintf('XML Attr: %s="%s"', this.name_, this.value_);
      end
    end
    
    function validateChildren(this, children)
      validateChildren@jl.xml.Node(this, children);
      if ~isempty(children)
        error('Attr nodes do not allow children');
      end
    end
  end
end
