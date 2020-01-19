classdef Thing < jl.util.DisplayableHandle
  
  properties
    % The underlying POI Thing object
    j
  end
  
  properties (Dependent)
  end
  
  methods
    
    function this = Thing(varargin)
      if nargin == 0
        return
      elseif nargin == 1
        arg = varargin{1};
        if isa(arg, 'org.apache.poi.ss.usermodel.Thing')
          % Wrap Java object
          this.j = arg;
        else
          error('jl:InvalidInput', 'Invalid input')
        end
      else
        error('jl:InvalidInput', 'Invalid inputs');
      end
    end
    
  end
  
end
