classdef (Sealed) xarray
  %XARRAY A multidimensional array with labeled indexes along its dims
  
  % TODO: Broadcasting and scalar expansion!
  % TODO: sortrows, N-D generalization of sortrows
  % TODO: more arithmetic wrappers
  % TODO: Aggregate arithmetic (sum, prod) with dim collapsing
  % TODO: DataUnits
  % TODO: 1- and 0-dim values: since we have labels and names along dims, a 2-D
  % xarray is not the same as a vector or a 0-by-0 empty! Decide what the
  % semantics of this are.
  
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
    
    function out = size(this, varargin)
      out = size(this.vals, varargin{:});
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
    
    function out = circshift(this, k, dim)
      narginchk(2, 3);
      out = this;
      if nargin == 2
        if isscalar(k)
          sz = size(this);
          ixDim = find(sz > 1, 1);
          out = circshift(this, k, ixDim);
        else
          tmp = this;
          for iDim = 1:numel(k)
            tmp = circshift(tmp, k(iDim), iDim);
          end
          out = tmp;
        end
      else
        out.vals = circshift(this.vals, k);
        out.labels{dim} = circshift(this.labels{dim}, k);
      end
    end
    
    function out = permute(this, dimorder)
      out = this;
      out.labels = this.labels(dimorder);
      out.dimNames = this.dimNames(dimorder);
      out.vals = permute(this.vals, dimorder);
    end
    
    function out = ipermute(this, dimorder)
      UNIMPLEMENTED
    end
    
    function out = ctranspose(this)
      if ~ismatrix(this)
        error('input for ctranspose must be a matrix; this is %d-d', ...
          ndims(this));
      end
      out.vals = ctranspose(this);
      out.labels = this.labels([2 1]);
      out.dimNames = this.dimNames([2 1]);
    end
    
    function out = transpose(this)
      if ~ismatrix(this)
        error('input for transpose must be a matrix; this is %d-d', ...
          ndims(this));
      end
      out.vals = transpose(this);
      out.labels = this.labels([2 1]);
      out.dimNames = this.dimNames([2 1]);
    end
    
    function out = squeeze(this)
      %SQUEEZE Remove singleton dimensions
      %
      % Note: Unlike squeeze() on regular arrays, squeeze() on an xarray is a
      % lossy operation! It discards the labels and dimNames for the squeezed
      % dimensions. This affects the semantics of the object!
      ixScalar = find(size(this) == 1);
      out = this;
      out.vals = squeeze(this.vals);
      out.labels(ixScalar) = [];
      out.dimNames(ixScalar) = [];
    end
    
    function out = shiftdim(this, n)
      if nargin == 1
        % TODO: implement 1-arg shiftdim
        error('The 1-arg form of shiftdim is unimplemented for xarray');
      end
      out = this;
      out.vals = shiftdim(this.vals, n);
      out.dimNames = circshift(this.dimNames, n);
      out.labels = circshift(this.labels, n);
    end
    
    function mustBeSameDimStructure(a, b)
      if ~isequaln(a.labels, b.labels)
        error(['a and b must have same dimension structure, but they ' ...
          'differ in their dimension labels']);
      end
      if ~isequaln(a.dimNames, b.dimNames)
        error(['a and b must have same dimension structure, but they ' ...
          'differ in their dimension names']);
      end
    end
    
    function out = eq(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = eq(a.vals, b.vals);
    end
    
    function out = ne(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = ne(a.vals, b.vals);
    end
    
    function out = lt(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = lt(a.vals, b.vals);
    end
    
    function out = le(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = le(a.vals, b.vals);
    end
    
    function out = gt(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = gt(a.vals, b.vals);
    end
    
    function out = ge(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = ge(a.vals, b.vals);
    end
    
    function out = or(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = or(a.vals, b.vals);
    end
    
    function out = and(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = and(a.vals, b.vals);
    end
    
    function out = xor(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = xor(a.vals, b.vals);
    end
    
    function out = not(this)
      out = this;
      out.vals = not(this.vals);
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
      [a,b] = promote(a, b);
      [a,b] = conform(a, b, varargin{:});
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
    
    function [a,b] = promote(a, b)
      if ~isa(b, 'xarray')
        b = xarray(b, a.labels, a.dimNames, a.valueName);
        validate(b);
      end
      if ~isa(a, 'xarray')
        a = xarray(a, b.labels, b.dimNames, b.valueName);
        validate(a);
      end
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
    
    function out = subsetByIndex(this, ixs)
      out = this;
      out.vals = this.vals(ixs{:});
      for iDim = 1:numel(ixs)
        ix = ixs{iDim};
        if isequal(ix, ':') ...
            || (islogical(ix) && all(ix, 'all')) ...
            || (isnumeric(ix) && isequal(ix, 1:size(this, iDim)))
          continue
        end
        out.labels{iDim} = this.labels{iDim}(ix);
      end
    end
    
    function out = subsetByLabel(this, labelss)
      ixs = labels2subs(this, labelss);
      out = subsetByIndex(this, ixs);
    end
    
    function out = labels2subs(this, labelss)
      mustBeA(labelss, 'cell');
      ixs = cell(size(labelss));
      for iDim = 1:numel(labelss)
        wantLabels = labelss{iDim};
        [tf,loc] = ismember(wantLabels, this.labels{iDim});
        if ~all(tf)
          error('Labels not found along dimension %d: %s', ...
            iDim, jl.utils.ellipses(wantLabels(~tf)));
        end
        ixs{iDim} = loc;
      end
      out = ixs;
    end
    
    function out = subsref(this, S)
      s = S(1);
      switch s.type
        case '()'
          out = subsetByIndex(this, s.subs);
        case '{}'
          out = subsetByLabel(this, s.subs);
        case '.'
          error('.-indexing is not supported by xarray');
      end
      if numel(S) > 1
        out = subsref(out, S(2:end));
      end
    end
    
    function out = subsasgn(this, S, rhs)
      if numel(S) > 1
        % TODO: Add support
        error('Chained subsasgn indexing is not supported by xarray');
      end
      s = S(1);
      out = this;
      switch s.type
        case '()'
          out.vals(s.subs{:}) = rhs;
        case '{}'
          ixs = labels2subs(this, s.subs);
          out.vals(ixs{:}) = rhs;
        case '.'
          error('.-indexing for assignment is not supported by xarray');
      end
    end
    
    function out = numArgumentsFromSubscript(this, S, indexingContext)
      out = 1;
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