classdef PrettyPrintOptions
  % PrettyPrintOptions Controls appearance of pretty-printing
  %
  % Properties:
  %
  %  attrsOnSeparateLines (logical,false*) - If true, then element
  %    attributes are each printed on a separate line. This makes it easier
  %    to read documents whose elements have many attributes, which would
  %    otherwise turn into really long lines.
  %
  %  expandDepth (double,Inf*) - How many levels deep to expand elements
  %    into multiple lines. Setting this to a low number lets you see the
  %    high-level structure of a document. NOTE: This one is still a work
  %    in progress.
  
  % TODO: Add a Depth option to coompletely elide deeper nodes
  
  properties
    attrsOnSeparateLines logical = false
    expandDepth double = Inf
  end
  
  methods
    function this = PrettyPrintOptions(varargin)
      % Construct a new PrettyPrintOptions
      %
      % jl.xml.PrettyPrintOptions(struct)
      % jl.xml.PrettyPrintOptions({'Name',Val, ...})
      % jl.xml.PrettyPrintOptions('Name',Val, ...)
      %
      % 'Name' can be the name of any property on this class.
      args = varargin;
      if nargin == 0
        return
      end
      if numel(args) > 1
        % Assume it's a name/val list
        in = args;
      else
        in = args{1};
      end
      if isa(in, 'jl.xml.PrettyPrintOptions')
        this = in;
      else
        in = jl.datastruct.cellrec(in);
        for i = 1:size(in, 1)
          this.(in{i,1}) = in{i,2};
        end
      end
    end
  end
end