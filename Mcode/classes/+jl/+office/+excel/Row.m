classdef Row < handle
  
  properties
    % The underlying POI Row object
    j
  end
  
  properties (Dependent)
  end
  
  methods
    
    function this = Row(varargin)
      if nargin == 0
        return
      elseif nargin == 1 && isa(varargin{1}, 'org.apache.poi.ss.usermodel.Row')
        % Wrap Java object
        this.j = varargin{1};
        return
      else
        error('jl:InvalidInput', 'Invalid inputs');
      end
    end
    
  end
end
