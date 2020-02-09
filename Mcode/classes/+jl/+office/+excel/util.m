classdef util
  %UTIL Utility functions for Excel
  
  methods (Static)
    
    function out = toCellOrRangeAddress(x)
      if isa(x, 'jl.office.excel.CellAddress') || ...
          isa(x, 'jl.office.excel.CellRangeAddress')
        out = x;
      elseif isnumeric(x)
        if numel(x) == 2
          out = jl.office.excel.CellAddress(x);
        elseif numel(x) == 4
          out = jl.office.excel.CellRangeAddress(x);
        else
          error('jl:InvalidInput', 'Invalid numel for numeric input: Must be 2 or 4, got %d', ...
            numel(x));
        end
      elseif ischar(x) || isstring(x)
        x = char(x);
        if any(x == ':')
          out = jl.office.excel.CellRangeAddress(x);
        else
          out = jl.office.excel.CellAddress(x);
        end
      else
        error('jl:InvalidInput', 'Invalid input type: %s', class(x));
      end
    end
    
    
  end
  
  methods (Access = private)
    
    function obj = util()
      % Private constructor to prevent instantiation
    end
    
  end
end

