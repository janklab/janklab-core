classdef PrettyPrintOptions
  % PrettyPrintOptions Controls appearance of pretty-printing
  
  properties
    attrsOnSeparateLines logical = false
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