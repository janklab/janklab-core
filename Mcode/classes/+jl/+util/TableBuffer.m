classdef TableBuffer
  % TABLEBUFFER A tool for incrementally building a table
  %
  % TableBuffer is for use when you are building a table from data that is
  % coming in incrementally and you don't know what the final number
  % of rows in the table is going to be.
  %
  % This class lets you build tables more efficiently than naively expanding
  % arrays inside a loop. When it expands the underlying buffers, it resizes
  % them in chunks, pre-allocating space for several additional elements.
  %
  % This class is a lot like Java's ArrayList class.
  %
  % Currently has the limitation that all variables must be single-column arrays
  % (column vectors).
  % TODO: Support multi-column array variables
  %
  % Example:
  %
  % tb = jl.util.TableBuffer({'x','str'})
  % tb = tb.addRow({1, "foo"});
  % tb = tb.addRow({2, "bar"});
  % tb = tb.addRow({3, "baz"});
  % t = table(tb)
  
  
  properties
    initialCapacity (1,1) double = 256
    variableNames string = string.empty
  end
  properties (SetAccess = private)
    nRows (1,1) double = 0
  end
  properties (Dependent = true)
    capacity
    nCols
  end
  properties (Access = private)
    % The actual buffer; a capacity-by-ncols cell array
    buf = {}
  end
  
  methods
    
    function this = TableBuffer(variableNames)
      % Construct a new object
      %
      % obj = TableBuffer()
      % obj = TableBuffer(variableNames)
      %
      % Creates a new TableBuffer holding zero rows of data, and with a capacity
      % of the default initial capacity.
      %
      % tableNames (string) is an optional list of variable names to use. These
      % will be used as the VariableNames when the buffer is converted
      % to a table.
      
      if nargin < 1
        return
      end
      if isempty(variableNames); variableNames = string.empty; end
      this.variableNames = variableNames;
    end
    
    function this = addRow(this, vals)
      %ADDROW Add a single row to this TableBuffer
      %
      % this = addRow(this, vals)
      %
      % Adds a single row of data to this object. If this buffer is currently
      % empty, initializes the buffer's storage, and sets its nCols to be the
      % number of elements in vals. If the addition would exceed this' capacity,
      % this's underlying storage is automatically expanded. The expansion is
      % done in large increments, pre-allocating many additional rows' worth of
      % buffer, for efficiency.
      %
      % vals must be a cell vector that is nCols long. Each vals{i} holds the
      % data to be appended to the corresponding column.
      %
      % Returns the updated TableBuffer object.
      this = this.addRows(vals);
    end
    
    function this = addRows(this, vals)
      %ADDROW Add a one or more rows to this TableBuffer
      %
      % this = addRows(this, vals)
      %
      % Adds one or more rows of data to this object. If this buffer is
      % currently empty, initializes the buffer's storage, and sets its nCols to
      % be the number of elements in vals. If the addition would exceed this'
      % capacity, this's underlying storage is automatically expanded. The
      % expansion is done in large increments, pre-allocating many additional
      % rows' worth of buffer, for efficiency.
      %
      % vals must be a cell vector that is nCols long. Each vals{i} holds
      % the data to be appended to the corresponding column.
      %
      % Returns the updated TableBuffer object.
      mustBeA(vals, 'cell');
      if isempty(this.buf)
        % Initialize buffer
        this.buf = vals(:)';
        for i = 1:this.nCols
          this.buf{i}(this.initialCapacity,:) = vals{i}(1,:);
        end
        this.nRows = size(vals{1}, 1);
      else
        % Add rows
        nNewRows = size(vals{1}, 1);
        nRowsAfterAdd = this.nRows + nNewRows;
        if nRowsAfterAdd > this.capacity
          % Expand if necessary
          newCapacity = max(nRowsAfterAdd, this.capacity * 2);
          for i = 1:this.nCols
            this.buf{i}(newCapacity,:) = this.buf{i}(1,:);
          end
        end
        for i = 1:this.nCols
          this.buf{i}(this.nRows+1:nRowsAfterAdd,:) = vals{i};
        end
        this.nRows = nRowsAfterAdd;
      end
    end
    
    function out = get.capacity(this)
      if isempty(this.buf)
        out = this.initialCapacity;
      else
        out = size(this.buf{1}, 1);
      end
    end
    
    function out = get.nCols(this)
      out = size(this.buf, 2);
    end
    
    function out = table(this)
      %TABLE Convert the buffered data to a table
      %
      % out = table(obj)
      %
      % This is the method you call when you're done buffering to convert the
      % accumulated data into a Matlab table array.
      %
      % Returns a table.
      cols = cell(1, this.nCols);
      for i = 1:this.nCols
        cols{i} = this.buf{i}(1:this.nRows,:);
      end
      if isempty(this.variableNames)
        out = table(cols{:});
      else
        out = table(cols{:}, 'VariableNames', this.variableNames);
      end
    end
    
    function out = struct(this)
      %STRUCT Convert the buffered data to a struct
      %
      % out = struct(obj)
      %
      % For this to work, obj.variableNames must be populated, and must contain
      % valid variable names.
      %
      % Returns a scalar struct.
      out = struct;
      for iCol = 1:this.nCols
        out.(this.variableNames{iCol}) = this.buf{iCol}(1:this.nRows,:);
      end
    end
    
  end
  
end