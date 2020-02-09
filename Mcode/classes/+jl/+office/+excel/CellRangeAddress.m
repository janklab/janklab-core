classdef CellRangeAddress < jl.util.DisplayableHandle
  % The address of a range of cells
  %
  % A CellRangeAddress specifies a range of cells (without specifying what sheet
  % they are on), in terms of the starting and ending row and column.
  %
  % CellRangeAddress knows how to handle both numeric (row m, col n) and string
  % ("A1:C5") style references.
  %
  % All row and column indexes in this class are 1-based.
  
  % TODO: Method to list all addresses in this range
  % TODO: Arithmetic to shift/expand/contract ranges
  
  properties
    % The underling Java POI object
    j
  end
  
  properties (Dependent)
    % Index of the first row
    firstRow
    % Index of the last row (inclusive)
    lastRow
    % Index of the first column
    firstCol
    % Index of the last column (inclusive)
    lastCol
    % Range size, as [numRows numCols]
    rangeSize
    % Number of rows in range
    numRows
    % Number of columns in range
    numCols
  end
  
  methods (Static)
    
    function out = a1ToRc(a1)
      % Convert an "A1:B2" style string range into numeric values
      %
      % out = jl.office.excel.CellRangeAddress.a1ToRc(a1)
      %
      % a1 is a char or string in "A1:D3" format.
      %
      % Returns a 1-by-4 numeric array.
      %
      % Raises an error if the input a1 string is not formatted correctly.
      a1 = char(a1);
      ix = find(a1 == ':');
      if isempty(ix)
        error('Cell range address input is missing a colon');
      elseif numel(ix) > 1
        error('Cell range address had multiple colons');
      end
      upLeftA1 = a1(1:ix-1);
      downRightA1 = a1(ix+1:end);
      upLeftRc = jl.office.excel.CellAddress.a1ToRc(upLeftA1);
      downRightRc = jl.office.excel.CellAddress.a1ToRc(downRightA1);
      out = [upLeftRc downRightRc];
    end
    
  end
  
  methods
    
    function this = CellRangeAddress(varargin)
      % Construct a new object
      %
      % obj = CellRangeAddress(a1RangeString)
      % obj = CellRangeAddress(upperLeft, lowerRight)
      % obj = CellRangeAddress(up, left, lower, right)
      % obj = CellRangeAddress([up, left, lower, right])
      if nargin == 0
        return
      end
      if isa(varargin{1}, 'jl.office.excel.CellRangeAddress')
        this = varargin{1};
        return
      end
      if isa(varargin{1}, 'org.apache.poi.ss.util.CellRangeAddressBase')
        this.j = varargin{1};
        return
      end
      
      switch nargin
        case 1
          arg = varargin{1};
          if isnumeric(arg)
            if ~isequal(size(arg), [1 4])
              error('Single numeric inputs must be 1-by-4 ([up, left, lower, right])');
            end
            rc = arg;
          elseif ischar(arg) || isstring(arg)
            arg = string(arg);
            rc = jl.office.excel.CellRangeAddress.a1ToRc(arg);
          else
            error('jl:InvalidInput', 'Invalid input: must be numeric or string; got %s', ...
              class(arg));
          end
        case 2
          upLeft = parseCellAddrArg(varargin{1});
          downRight = parseCellAddrArg(varargin{2});
          rc = [upLeft downRight];
        case 4
          for i = 1:nargin
            mustBeScalarNumeric(varargin{i}, sprintf('Input %d', i));
          end
          rc = [varargin{:}];
        otherwise
          error('jl:InvalidInput', 'Invalid number of inputs: %d. Need 1, 2, or 4', ...
            nargin);
      end
      this.j = org.apache.poi.ss.util.CellRangeAddress(rc(1)-1, rc(3)-1, rc(2)-1, rc(4)-1);
    end
    
    function out = get.firstRow(this)
      out = this.j.getFirstRow + 1;
    end
    
    function out = get.lastRow(this)
      out = this.j.getLastRow + 1;
    end
    
    function out = get.firstCol(this)
      out = this.j.getFirstColumn + 1;
    end
    
    function out = get.lastCol(this)
      out = this.j.getLastColumn + 1;
    end
    
    function set.firstRow(this, val)
      this.j.setFirstRow(val - 1);
    end
    
    function set.lastRow(this, val)
      this.j.setLastRow(val - 1);
    end
    
    function set.firstCol(this, val)
      this.j.setFirstCol(val - 1);
    end
    
    function set.lastCol(this, val)
      this.j.setLastCol(val - 1);
    end
    
    function out = get.numCols(this)
      out = this.lastCol - this.firstCol + 1;
    end
    
    function out = get.numRows(this)
      out = this.lastRow - this.firstRow + 1;
    end
    
    function out = get.rangeSize(this)
      out = [this.numRows this.numCols];
    end
    
    function out = containsColumn(this, index)
      out = this.j.containsColumn(index - 1);
    end
    
    function out = containsRow(this, index)
      out = this.j.containsRow(index - 1);
    end
    
    function out = numberOfCells(this)
      out = this.j.getNumberOfCells;
    end
    
    function out = intersects(this, other)
      other = jl.office.excel.CellRangeAddress(other);
      out = this.j.intersects(other.j);
    end
    
    function out = isFullColumnRange(this)
      out = this.j.isFullColumnRange;
    end
    
    function out = isFullRowRange(this)
      out = this.j.isFullRowRange;
    end
    
    function out = isInRange(this, cell)
      % Test whether a given cell is in this range
      %
      % out = isInRange(obj, cell)
      % out = isInRange(obj, cellAddress)
      % out = isInRange(obj, cellReference)
      %
      % Cell is a Cell object.
      %
      % CellAddress is the address of a cell, given as a CellAddress object, a
      % [row column] numeric address, or an "A1" string address.
      %
      % CellReference is a CellReference object.
      %
      % Returns a scalar logical.
      if isa(cell, 'jl.office.excel.CellReference')
        out = this.j.isInRange(cell.j);
      elseif isa(cell, 'jl.office.excel.Cell')
        out = this.j.isInRange(cell.j);
      else
        cell = jl.office.excel.CellAddress(cell);
        out = this.j.isInRange(cell);
      end
    end
    
    function validate(this, spreadsheetVersion)
      % Validate this against the range limits of a given spreadsheet version
      %
      % validate(obj, spreadsheetVersion)
      %
      % Raises an error if the validation fails.
      mustBeA(spreadsheetVersion, 'jl.office.excel.SpreadsheetVersion')
      this.j.validate(spreadsheetVersion.j);
    end
    
    function out = toJavaArray(obj)
      out = javaArray('org.apache.poi.ss.util.CellRangeAddress', numel(obj));
      for i = 1:numel(obj)
        out(i) = obj(i).j;
      end
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[CellRangeAddress: (%d, %d) to (%d, %d) (%s:%s)]', ...
        this.firstRow, this.firstCol, this.lastRow, this.lastCol, ...
        jl.office.excel.CellAddress.rcToA1(this.firstRow, this.firstCol), ...
        jl.office.excel.CellAddress.rcToA1(this.lastRow, this.lastCol));
    end
    
  end
  
end

function out = parseCellAddrArg(x)
if isnumeric(x)
  if numel(x) ~= 2
    error('jl:InvalidInput', 'Numeric cell address must be 2-long, got a %d-long', numel(x));
  end
  out = x;
elseif isstringy(x)
  x = string(x);
  mustBeScalar(x);
  out = jl.office.excel.CellAddress.rcToA1(x);
else
  error('jl:InvalidInput', 'Cell address arg must be numeric or stringy, got %s', ...
    class(x));
end
end