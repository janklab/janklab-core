classdef (Sealed) xarray
  %XARRAY A multidimensional array with labeled indexes along its dims
  
  % TODO: subsref, subsasgn, with {} support for indexing by label
  % TODO: conform1union
  % TODO: Broadcasting!
  % TODO: sortrows, N-D generalization of sortrows
  % TODO: more arithmetic wrappers
  % TODO: isequal, isequaln, eq, ne, < > <= >= relops
  % TODO: Promotion of plain arrays in arithmetic and relops
  % TODO: Aggregate arithmetic (sum, prod) with dim collapsing
  % TODO: squeeze
  % TODO: circshift, permute, ipermute, ctranspose, transpose
  % TODO: shiftdims
  % TODO: DataUnits
  
  properties
    vals = []
    labels cell = {}
    dimNames string = string.empty
    valueName (1,1) string = string(missing)
  end
  properties (Dependent = true)
    valueType
  end
  
  methods (Static)
    function out = empty()
      out = xarray;
    end
  end
  
  methods
    
    function this = xarray(vals, labels, dimNames, valueName)
      if nargin < 3 || isempty(dimNames); dimNames = string.empty; end
      if nargin < 4 || isempty(valueName); valueName = string.empty; end
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
      this.valueName = valueName;
      validate(this);
    end
    
    function out = get.valueType(this)
      out = class(this.vals);
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
    
    function out = dispstrs(this)
      out = dispstrs(this.vals);
    end
    
    function out = dispstr(this)
      %DISPSTR Custom display string for array
      
      % TODO: Add dim names
      out = sprintf('xarray (%s): %s', ...
        this.valueType, size2str(size(this)));
    end
    
    function out = mat2str(this)
      out = sprintf('xarray(%s, %s, %s)', ...
        mat2str(this.vals), mat2str(this.labels), mat2str(this.dimNames));
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
    
    function out = isnan(this)
      out = isnan(this.vals);
    end
    
    function out = ismissing(this)
      out = ismissing(this.vals);
    end
    
    function out = isempty(this)
      out = isempty(this.vals);
    end
    
    function out = isfinite(this)
      out = isfinite(this.vals);
    end
    
    function out = isreal(this)
      out = isreal(this.vals);
    end
    
    function out = isrow(this)
      out = isrow(this.vals);
    end
    
    function out = ismatrix(this)
      out = ismatrix(this.vals);
    end
    
    function out = iscolumn(this)
      out = iscolumn(this.vals);
    end
    
    function out = isvector(this)
      out = isvector(this.vals);
    end
    
    function out = isscalar(this)
      out = isscalar(this.vals);
    end
    
    function varargout = apply(fcn, a, b, varargin)
      %APPLY Apply a two-arg function to input xarrays
      %
      % varargout = apply(fcn, a, b)
      % varargout = apply(fcn, , ..., mode)
      % varargout = apply(fcn, , ..., 'broadcast')
      % varargout = apply(fcn, , ..., opts)
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
      %
      % If 'broadcast' is passed, it enables broadcasting. This expands the
      % input arrays along dimensions which are absent, but present in the other
      % argument. Presence is detected based on dimension name.
      %
      % opts (struct, jl.xarray.ConformOptions) is an options argument that
      % controls various aspects of conform's behavior. See its helptext for
      % details.
      %
      % See also:
      % jl.xarray.ConformOptions
      [a, b] = conform(a, b, varargin{:});
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

    function out = uminus(this)
      out = this;
      out.vals = uminus(this.vals);
    end
    
    function out = sortdims(this)
      %SORTDIMS Sort this based on its dimension labels
      out = this;
      for iDim = 1:ndims(this)
        [~,ix] = sort(this.labels{iDim});
        out = subsetAlongDim(out, iDim, ix);
      end
    end
    
    function out = cat(dim, varargin)
      args = varargin;
      tmp = args{1};
      mustBeA(tmp, 'xarray', 'input 2');
      % TODO: Check values name and dim name
      for i = 2:numel(args)
        mustBeA(args{i}, 'xarray', sprintf('input %d', i+1));
        [tmp,b] = conform(tmp, args{i}, {'excludeDims',dim});
        collisions = intersect(tmp.labels{dim}, b.labels{dim});
        if ~isempty(collisions)
          error('Duplicate labels in inputs for dimension %d: %s', ...
            dim, jl.utils.ellipses(collisions));
        end
        newLabels = [tmp.labels{dim} b.labels{dim}];
        newValues = cat(dim, tmp.values, b.values);
        tmp.labels{dim} = newLabels;
        tmp.values = newValues;
      end
      out = tmp;
    end
    
    function out = horzcat(varargin)
      out = cat(2, varargin{:});
    end
    
    function out = vertcat(varargin)
      out = cat(1, varargin{:});
    end
    
    function promote(a, b)
    end
    
    function [a2, b2] = conform(a, b, varargin)
      %CONFORM Rearrange input xarrays to have the same dimensions
      mustBeA(a, 'xarray');
      mustBeA(b, 'xarray');
      args = varargin;
      
      opts = jl.xarray.ConformOptions;
      while ischar(args{end}) || isstring(args{end}) || isstruct(args{end}) ...
          || isa(args{end}, 'jl.xarray.ConformOptions')
        arg = args{end};
        args(end) = [];
        if ischar(arg) || isstring(arg)
          switch arg
            case ["union" "intersect"]
              opts.mode = arg;
            case "broadcast"
              opts.broadcast = true;
            case "sort"
              opts.sortLabels = true;
            otherwise
              error('jl:InvalidInput', 'Invalid string option: %s', arg);
          end
        else
          opts = jl.xarray.ConformOptions(arg);
        end
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
          [a2,b2] = conform1union(a, b, opts);
        case 'intersect'
          [a2,b2] = conform1intersect(a, b, opts);
        otherwise
          error('jl:InvalidInput', 'Invalid mode argument: %s', mode);
      end
    end
    
    function out = unpivot(this)
      %UNPIVOT Unpivot an xarray into a table
      %
      % out = unpivot(obj)
      %
      % Converts the xarray obj into a table by unpivoting its dimensions.
      
      % TODO: DropMissing option
      % TODO: Expand to take multiple xarrays as inputs, to be the inverse of
      % the multi-value-column pivot().
      
      sz = size(this);
      keyss = cell(1, ndims(this));
      keyCols = this.dimNames;
      % TODO: Fill in empty dimNames with default values
      for iDim = 1:ndims(this)
        sz2 = sz;
        sz2(iDim) = 1;
        sz2b = ones(1, ndims(this));
        sz2b(iDim) = sz(iDim);
        keys = repmat(reshape(this.labels{iDim}, sz2b), sz2);
        keyss{iDim} = keys(:);
      end
      outVals = this.vals(:);
      
      colVals = [keyss outVals];
      if ismissing(this.valueName)
        % TODO: Uniqueify this
        valueCol = 'Value';
      else
        valueCol = this.valueName;
      end
      colNames = [keyCols valueCol];
      out = table(colVals{:}, 'VariableNames',colNames);
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
        valsOut = repmat(fillValFor(valsIn), sz);
        valsOut(ix) = valsIn;
        xarr.vals = valsOut;
        xarr.valueName = valCols{iOut};
        varargout{iOut} = xarr;
      end
    end
    
  end
  
  methods (Access = private)
    
    function [a2,b2] = conform1intersect(a, b, opts)
      mustBeA(opts, 'jl.xarray.ConformOptions');
      for iDim = 1:ndims(a)
        if ismember(iDim, opts.excludeDims)
          continue
        end
        aLabels = a.labels{iDim};
        bLabels = b.labels{iDim};
        [tf,loc] = ismember(aLabels, bLabels);
        a2 = subsetAlongDim(a, iDim, tf);
        b2 = subsetAlongDim(b, iDim, loc(tf));
      end
    end
    
    function [a,b] = conform1union(a, b, opts)
      [aIn,bIn] = deal(a, b); %#ok<ASGLU> This is just for debugging
      mustBeA(opts, 'jl.xarray.ConformOptions');
      for iDim = 1:ndims(a)
        if ismember(iDim, opts.excludeDims)
          continue
        end
        aLabels = a.labels{iDim};
        bLabels = b.labels{iDim};
        tf = ismember(aLabels, bLabels);
        tf2 = ismember(bLabels, aLabels);
        addLabelsA = bLabels(~tf2);
        addLabelsB = aLabels(~tf);
        newLabelsA = [aLabels addLabelsA];
        newLabelsB = [bLabels addLabelsB];
        newLabels = newLabelsA;
        if opts.sortLabels
          newLabels = sort(newLabels);
        end
        newLength = numel(newLabels);
        newValsA = expandValsAlong(a.vals, iDim, newLength);
        newValsB = expandValsAlong(b.vals, iDim, newLength);
        
        a.vals = newValsA;
        a.labels{iDim} = newLabelsA;
        b.vals = newValsB;
        b.labels{iDim} = newLabelsB;
        
        [~,loc] = ismember(newLabels, newLabelsA);
        a = subsetAlongDim(a, iDim, loc);
        [~,loc] = ismember(newLabels, newLabelsB);
        b = subsetAlongDim(b, iDim, loc);
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

function out = fillValFor(x)
%FILLVALFOR Determine the fill value for a type

try
  out = feval(class(x), missing);
  return
catch err %#ok<NASGU>
  % Oh well. Not everything supports missing. Fall through and do it through
  % implicit expansion.
end

if isempty(x)
  x = feval(class(x)); % Hope this produces a valid scalar object
end
tmp = x(1);
tmp(3) = x(1);
out = tmp(2);
end

function out = expandValsAlong(vals, ixDim, newLength)
fill = fillValFor(vals);
out = vals;
ixs = repmat({':'}, [1 ndims(vals)]);
oldLength = size(vals, ixDim);
ixs{ixDim} = oldLength+1:newLength;
out(ixs{:}) = fill;
end