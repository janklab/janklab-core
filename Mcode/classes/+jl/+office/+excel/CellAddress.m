classdef CellAddress < jl.util.DisplayableHandle
  
  properties
    % The underlying POI CellAddress object
    j
  end
  
  properties (Dependent)
    row
    column
    a1
  end
  
  methods (Static)
    
    function out = rcToA1(r, c)
      if nargin == 1
        c = r(:,2);
        r = r(:,1);
      end
      
      x = floor((c-27)/(26^2));
      x = max(x, 0);
      c = c - x*26^2;
      
      y = floor((c-1)/ 26);
      c = c - y*26;
      
      Col1 = c;
      
      Indx = y > 0;
      Col1(Indx) = max(Col1(Indx),1);
      
      Indx = x > 0;
      y(Indx) = max(y(Indx),1);
      
      letterA = double('A');
      colStr = [x(:) y(:) Col1(:)] + letterA - 1;
      colStr(colStr==letterA) = 32;
      
      out = cellstr( [char(colStr) strjust(num2str(r(:)), 'left')] );
      out = strtrim(out);
      out = string(out);
      out = reshape(out, size(r));
    end
    
    function varargout = a1ToRc(a1)
      a1 = string(a1);
      a1 = upper(a1);
      
      check = regexp(in,'\D*\d*','match');
      if any(cellfun('isempty', check))
        error('Unrecognized Excel cell references');
      end
      
      rStr = regexp(in, '\d*', 'match');
      rStr = cat(2, rStr{:});
      r = str2double(rStr);
      
      cStr = regexp(in,'\D*', 'match');
      cStr = cat(2, cStr{:});
      cStr = strjust(char(cStr{:}), 'right');
      
      letterA = double('A');
      c = double(cStr) - letterA + 1;
      
      factors = 26 .^ (size(c,2)-1:-1:0);
      c = c * factors(:);
      
      if nargout == 2
        sz = size(a1);
        varargout = { reshape(r, sz), reshape(c, sz) };
      else
        varargout = { [r(:) c(:)] };
      end
    end
    
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
    
    function out = get.a1(this)
      out = jl.office.excel.CellAddress.rcToA1(this.row, this.column);
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[CellAddress: %s r=%d, c=%d]', ...
        this.a1, this.row, this.column);
    end

  end
  
end
