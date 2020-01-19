classdef Formula < jl.util.DisplayableHandle
  
  properties (SetAccess = private)
    % The string value of the formula
    str string = string(missing);
  end
  
  methods
    
    function this = Formula(str)
      if nargin == 0
        return
      end
      this.str = str;
    end
    
    function out = dispstr_scalar(this)
      out = sprintf('[Formula: %s]', this.str);
    end
    
  end
  
end