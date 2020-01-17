classdef xarray
  %XARRAY A multidimensional array with labeled indexes along its dims
  
  properties
    labels cell = {}
    dimNames string = string.empty
    vals = []
  end
  
  methods (Static)
    function out = empty()
      out = xarray;
    end
  end
  
  methods
    
    function this = xarray(vals, labels, dimNames)
      if nargin < 3 || isempty(dimNames); dimNames = string.empty; end
      if nargin == 0
        return
      end
      if isa(vals, 'xarray')
        this = vals;
        return
      end
      this.vals = vals;
      this.labels = labels;
      dimNames = string(dimNames);
      if isempty(dimNames)
        dimNames = repmat(string(missing), [1 ndims(vals)]);
      end
      this.dimNames = dimNames;
      validate(this);
    end
    
    function validate(this)
      mustBeA(this.labels, 'cell');
      if ~isequal(numel(this.labels), ndims(this.vals))
        error('Inconsistent dimensions: %d dims in vals, but %d label lists', ...
          ndims(this.vals), numel(this.labels));
      end
      if ~isequal(ndims(this.vals), numel(this.dimNames))
        error('Inconsistent dimensions: %d dims in vals, but %d dimNames', ...
          ndims(this.vals), numel(this.dimNames));
      end
      for i = 1:ndims(this)
        if numel(this.labels{i}) ~= size(this.vals, i)
          error('Inconsistent dimensions: vals is %d long along dimension %d, but labels{%d} is %d long', ...
            size(this.vals, i), i, i, numel(this.labels{i}));
        end
      end
    end
    
    function disp(this)
      fprintf('xarray: %s\n', size2str(size(this)));
      for i = 1:ndims(this)
        if ismissing(this.dimNames(i))
          fprintf('  dim %d: %s\n', i, jl.util.ellipses(this.labels{i}));
        else
          fprintf('  dim %d ("%s"): %s\n', i, this.dimNames(i), ...
            jl.util.ellipses(this.labels{i}));
        end
      end
      if numel(this) < 100
        disp(this.vals);
      end
    end
    
    function out = ndims(this)
      out = ndims(this.vals);
    end
    
    function out = size(this)
      out = size(this.vals);
    end
    
    function out = numel(this)
      out = numel(this.vals);
    end
    
    function out = length(this)
      out = length(this.vals);
    end
    
    function varargout = apply(fcn, a, b, mode)
      %APPLY Apply a two-arg function to input xarrays
      %
      % varargout = apply(fcn, a, b)
      % varargout = apply(fcn, a, b)
      %
      % This conforms the xarray arguments, and then applies the given function
      % to their values.
      %
      % fcn (function handle) is the function to apply to a and b's values once
      % conformed. It must return one or more arrays of the same size as its
      % input.
      %
      % mode (char) may be 'union' or 'intersect'. It controls the mode used
      % when the conform is done.
      if nargin < 4 || isempty(mode); mode = 'union'; end
      [a, b] = conform(a, b, mode);
      outvals = cell(1, nargout);
      outvals{:} = fcn(a.vals, b.vals);
      varargout = cell(size(outvals));
      for i = 1:numel(outvals)
        outvals{i} = xarray(outvals{i}, a.labels, a.dimNames);
      end
    end
    
    function out = plus(a, b, mode)
      if nargin < 3 || isempty(mode); mode = 'union'; end
      out = apply(@plus, a, b, mode);
    end
    
    function out = minus(a, b, mode)
      if nargin < 3 || isempty(mode); mode = 'union'; end
      out = apply(@minus, a, b, mode);
    end
        
    function [a2, b2] = conform(a, b, varargin)
      %CONFORM Rearrange input xarrays to have the same dimensions
      mustBeA(a, 'xarray');
      mustBeA(b, 'xarray');
      args = varargin;
      if ischar(args{end}) || isstring(args{end})
        mode = args{end};
        args(end) = [];
      else
        mode = 'union';
      end

      if ~isempty(args)
        error('jl:InvalidInput', 'Too many arguments');
      end
      
      % Check input consistency
      
      if ndims(a) ~= ndims(b)
        error('jl:InvalidInput', 'Inconsistent dimensions: a has %d dims and b has %d dims', ...
          ndims(a), ndims(b));
      end
      for i = 1:ndims(a)
        if ~ismissing(a.dimNames(i)) && ~ismissing(b.dimNames(i)) ...
            && (a.dimNames(i) ~= b.dimNames(i))
          error('jl:InvalidInput', ['Inconsistent dimensions: dim %d ' ...
            'of a is named "%s", but dim %d of b is "%s"'], ...
            i, a.dimNames(i), i, b.dimNames(i));
        end
      end
      
      % Do the conform
      
      switch mode
        case 'union'
          [a2,b2] = conform1union(a, b);
        case 'intersect'
          [a2,b2] = conform1intersect(a, b);
        otherwise
          error('jl:InvalidInput', 'Invalid mode argument: %s', mode);
      end
    end
  end
  
  methods (Static)
    
    function varargout = pivot(tbl, keyCols, valCols)
      %PIVOT Pivot a table into a xarray(s)
      %
      % varargout = pivot(tbl, keyCols, valCols)
      %
      % Pivots the given table
      %
      % tbl is a table, or something that works like one.
      %
      % keyCols (string) is a list of the columns/variables in tbl to treat as
      % keys. They are pivoted out into the dimensions of the output xarrays.
      %
      % valCols (string) is a list of the value columns that will be pivoted
      % into the values of the output xarrays. Each valCol will produce one
      % argout which contains the values from that corresponding input column.
      % Defaults to all columns in tbl which are not named in keyCols.
      if nargin < 3; valCols = []; end
      keyCols = string(keyCols);
      cols = tbl.Properties.VariableNames;
      tf = ismember(keyCols, cols);
      if ~all(tf)
        error('Named variables not found in input table: %s', ...
          strjoin(keyCols(~tf), ', '));
      end
      if isempty(valCols)
        valCols = setdiff(cols, keyCols);
      end
      
      labels = cell(1, numel(keyCols));
      ixs = cell(1, numel(keyCols));
      for iKey = 1:numel(keyCols)
        keyVals = tbl.(keyCols{iKey});
        [uKeys,Indx,Jndx] = unique(keyVals);
        labels{iKey} = uKeys;
        % TODO: Figure out how to do the index mapping
        ixs{iKey} = Jndx;
      end
      % Here's the magic
      sz = cellfun(@numel, labels);
      ix = sub2ind(sz, ixs{:});
      [uIx,ix2,jx2] = unique(ix);
      if numel(uIx) < numel(ix)
        error(['Value collision! Multiple rows in the input mapped ' ...
          'to the same element in the output']);
        % TODO: Better error message
      end
      
      varargout = cell(1, numel(valCols));
      template = xarray;
      template.labels = labels;
      template.dimNames = keyCols;
      for iOut = 1:numel(valCols)
        xarr = template;
        valsIn = tbl.(valCols(iOut));
        xarr.vals = valsIn(ix);
        varargout{iOut} = xarr;
      end
    end
    
  end
  
  methods (Access = private)
    
    function [a2,b2] = conform1intersect(a, b)
      for iDim = 1:ndims(a)
        aLabels = a.labels{iDim};
        bLabels = b.labels{iDim};
        [tf,loc] = ismember(aLabels, bLabels);
        a2 = subsetAlongDim(a, iDim, tf);
        b2 = subsetAlongDim(b, iDim, loc(tf));
      end
    end
    
    function [a2,b2] = conform1union(a, b)
      for iDim = 1:ndims(a)
        aLabels = a.labels{iDim};
        bLabels = b.labels{iDim};
        [tf,loc] = ismember(aLabels, bLabels);
        % Pull up the things in b that are already in a
        
        % Expand b to have the things not in a
        
        % Expand a to have the things not in b
        
        UNIMPLEMENTED
      end
    end
    
    function out = subsetAlongDim(this, iDim, ix)
      out = this;
      ixs = repmat({':'}, [1 ndims(this)]);
      ixs{iDim} = ix;
      out.vals = this.vals(ixs{:});
      out.labels{iDim} = this.labels{iDim}(ix);
    end
  end
end