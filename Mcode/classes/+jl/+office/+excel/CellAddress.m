classdef CellAddress < jl.util.DisplayableHandle
  
  properties
    % The underlying POI CellAddress object
    j
  end
  
  properties (Dependent)
    row
    column
  end
  
  methods
    
    function this = CellAddress(varargin)
      %CELLADDRESS A cell address
      %
      % jl.office.excel.CellAddress(jCellAddress)
      % jl.office.excel.CellAddress(jCellReference)
      % jl.office.excel.CellAddress(str)
      % jl.office.excel.CellAddress(row, col)
      if nargin == 0
        return
      elseif nargin == 1
        arg = varargin{1};
        if isa(arg, 'org.apache.poi.ss.util.CellAddress')
          % Wrap Java object
          this.j = varargin{1};
        elseif isa(arg, 'org.apache.poi.ss.util.CellReference')
          this.j = org.apache.poi.ss.util.CellAddress(arg);
        elseif ischar(arg) || isstring(arg)
          this.j = org.apache.poi.ss.util.CellAddress(arg);
        end
      elseif nargin == 2
        this.j = org.apache.poi.ss.util.CellAddress(varargin{1}, varargin{2});
      else
        error('jl:InvalidInput', 'Invalid inputs');
      end
    end
    
    function out = get.row(this)
      out = this.j.getRow;
    end
    
    function out = get.column(this)
      out = this.j.getColumn;
    end
    
    function out = dispstr_scalar(this)
      out = sprintf('[r=%d, c=%d]', this.row, this.column);
    end
    
  end
end
